/****************************************************************************
 Copyright (c) 2010-2012 cocos2d-x.org
 Copyright (c) 2012 James Chen
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
#include "CEditBoxImplIOS.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#define kLabelZOrder  9999

#include "CEditBox.h"
#import "CCEAGLView-ios.h"

#define getEditBoxImplIOS() ((cocos2d::cocoswidget::CEditBoxImplIOS*)editBox_)

static const int CC_EDIT_BOX_PADDING = 5;

@implementation CCustomUITextField
- (CGRect)textRectForBounds:(CGRect)bounds
{
    auto glview = cocos2d::Director::getInstance()->getOpenGLView();

    float padding = CC_EDIT_BOX_PADDING * glview->getScaleX() / glview->getContentScaleFactor();
    return CGRectMake(bounds.origin.x + padding, bounds.origin.y + padding,
                      bounds.size.width - padding*2, bounds.size.height - padding*2);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end


@implementation CEditBoxImplIOS_objc

@synthesize textField = textField_;
@synthesize editState = editState_;
@synthesize editBox = editBox_;

- (void)dealloc
{
    [textField_ resignFirstResponder];
    [textField_ removeFromSuperview];
    self.textField = NULL;
    [super dealloc];
}

-(id) initWithFrame: (CGRect) frameRect editBox: (void*) editBox
{
    self = [super init];
    
    if (self)
    {
        editState_ = NO;
        self.textField = [[[CCustomUITextField alloc] initWithFrame: frameRect] autorelease];

        [textField_ setTextColor:[UIColor whiteColor]];
        textField_.font = [UIFont systemFontOfSize:frameRect.size.height*2/3]; //TODO need to delete hard code here.
		textField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField_.backgroundColor = [UIColor clearColor];
        textField_.borderStyle = UITextBorderStyleNone;
        textField_.delegate = self;
        textField_.hidden = true;
		textField_.returnKeyType = UIReturnKeyDefault;
        [textField_ addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
        self.editBox = editBox;
    }
    
    return self;
}

-(void) doAnimationWhenKeyboardMoveWithDuration:(float)duration distance:(float)distance
{
    auto view = cocos2d::Director::getInstance()->getOpenGLView();
    CCEAGLView *eaglview = (CCEAGLView *) view->getEAGLView();

    [eaglview doAnimationWhenKeyboardMoveWithDuration:duration distance:distance];
}

-(void) setPosition:(CGPoint) pos
{
    CGRect frame = [textField_ frame];
    frame.origin = pos;
    [textField_ setFrame:frame];
}

-(void) setContentSize:(CGSize) size
{
    CGRect frame = [textField_ frame];
    frame.size = size;
    [textField_ setFrame:frame];
}

-(void) visit
{
    
}

-(void) openKeyboard
{
    auto view = cocos2d::Director::getInstance()->getOpenGLView();
    CCEAGLView *eaglview = (CCEAGLView *) view->getEAGLView();

    [eaglview addSubview:textField_];
    [textField_ becomeFirstResponder];
}

-(void) closeKeyboard
{
    [textField_ resignFirstResponder];
    [textField_ removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
    if (sender == textField_) {
        [sender resignFirstResponder];
    }
    return NO;
}

-(void)animationSelector
{
    auto view = cocos2d::Director::getInstance()->getOpenGLView();
    CCEAGLView *eaglview = (CCEAGLView *) view->getEAGLView();

    [eaglview doAnimationWhenAnotherEditBeClicked];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)sender        // return NO to disallow editing.
{
    CCLOG("textFieldShouldBeginEditing...");
    editState_ = YES;

    auto view = cocos2d::Director::getInstance()->getOpenGLView();
    CCEAGLView *eaglview = (CCEAGLView *) view->getEAGLView();

    if ([eaglview isKeyboardShown])
    {
        [self performSelector:@selector(animationSelector) withObject:nil afterDelay:0.0f];
    }
    cocos2d::cocoswidget::CEditBoxDelegate* pDelegate = getEditBoxImplIOS()->getDelegate();
    if (pDelegate != NULL)
    {
        pDelegate->editBoxEditingDidBegin(getEditBoxImplIOS()->getEditBox());
    }
    
#if CC_ENABLE_SCRIPT_BINDING
    cocos2d::cocoswidget::CEditBox*  pEditBox= getEditBoxImplIOS()->getEditBox();
    if (NULL != pEditBox && 0 != pEditBox->getScriptEditBoxHandler())
    {        
        cocos2d::CommonScriptData data(pEditBox->getScriptEditBoxHandler(), "began",pEditBox);
        cocos2d::ScriptEvent event(cocos2d::kCommonEvent,(void*)&data);
        cocos2d::ScriptEngineManager::getInstance()->getScriptEngine()->sendEvent(&event);
    }
#endif
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)sender
{
    CCLOG("textFieldShouldEndEditing...");
    editState_ = NO;
    getEditBoxImplIOS()->refreshInactiveText();
    
    cocos2d::cocoswidget::CEditBoxDelegate* pDelegate = getEditBoxImplIOS()->getDelegate();
    if (pDelegate != NULL)
    {
        pDelegate->editBoxEditingDidEnd(getEditBoxImplIOS()->getEditBox());
        pDelegate->editBoxReturn(getEditBoxImplIOS()->getEditBox());
    }
    
#if CC_ENABLE_SCRIPT_BINDING
    cocos2d::cocoswidget::CEditBox*  pEditBox= getEditBoxImplIOS()->getEditBox();
    if (NULL != pEditBox && 0 != pEditBox->getScriptEditBoxHandler())
    {
        cocos2d::CommonScriptData data(pEditBox->getScriptEditBoxHandler(), "ended",pEditBox);
        cocos2d::ScriptEvent event(cocos2d::kCommonEvent,(void*)&data);
        cocos2d::ScriptEngineManager::getInstance()->getScriptEngine()->sendEvent(&event);
        memset(data.eventName, 0, sizeof(data.eventName));
        strncpy(data.eventName, "return", sizeof(data.eventName));
        event.data = (void*)&data;
        cocos2d::ScriptEngineManager::getInstance()->getScriptEngine()->sendEvent(&event);
    }
#endif
    
	if(editBox_ != nil)
	{
		getEditBoxImplIOS()->onEndEditing();
	}
    return YES;
}

/**
 * Delegate method called before the text has been changed.
 * @param textField The text field containing the text.
 * @param range The range of characters to be replaced.
 * @param string The replacement string.
 * @return YES if the specified text range should be replaced; otherwise, NO to keep the old text.
 */
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (getEditBoxImplIOS()->getMaxLength() < 0)
    {
        return YES;
    }
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    return newLength <= getEditBoxImplIOS()->getMaxLength();
}

/**
 * Called each time when the text field's text has changed.
 */
- (void) textChanged
{
    // NSLog(@"text is %@", self.textField.text);
    cocos2d::cocoswidget::CEditBoxDelegate* pDelegate = getEditBoxImplIOS()->getDelegate();
    if (pDelegate != NULL)
    {
        pDelegate->editBoxTextChanged(getEditBoxImplIOS()->getEditBox(), getEditBoxImplIOS()->getText());
    }
    
#if CC_ENABLE_SCRIPT_BINDING
    cocos2d::cocoswidget::CEditBox*  pEditBox= getEditBoxImplIOS()->getEditBox();
    if (NULL != pEditBox && 0 != pEditBox->getScriptEditBoxHandler())
    {
        cocos2d::CommonScriptData data(pEditBox->getScriptEditBoxHandler(), "changed",pEditBox);
        cocos2d::ScriptEvent event(cocos2d::kCommonEvent,(void*)&data);
        cocos2d::ScriptEngineManager::getInstance()->getScriptEngine()->sendEvent(&event);
    }
#endif
}

@end


NS_CC_WIDGET_BEGIN

EditBoxImpl* __createSystemEditBox(CEditBox* pEditBox)
{
    return new CEditBoxImplIOS(pEditBox);
}

CEditBoxImplIOS::CEditBoxImplIOS(CEditBox* pEditText)
: EditBoxImpl(pEditText)
, _label(nullptr)
, _labelPlaceHolder(nullptr)
, _anchorPoint(Vec2(0.5f, 0.5f))
, _systemControl(nullptr)
, _maxTextLength(-1)
{
    auto view = cocos2d::Director::getInstance()->getOpenGLView();

    _inRetinaMode = view->isRetinaDisplay();
}

CEditBoxImplIOS::~CEditBoxImplIOS()
{
    [_systemControl release];
}

void CEditBoxImplIOS::doAnimationWhenKeyboardMove(float duration, float distance)
{
    if ([_systemControl isEditState] || distance < 0.0f)
    {
        [_systemControl doAnimationWhenKeyboardMoveWithDuration:duration distance:distance];
    }
}

bool CEditBoxImplIOS::initWithSize(const Size& size)
{
    do 
    {
        auto glview = cocos2d::Director::getInstance()->getOpenGLView();

        CGRect rect = CGRectMake(0, 0, size.width * glview->getScaleX(),size.height * glview->getScaleY());

        if (_inRetinaMode)
        {
            rect.size.width /= 2.0f;
            rect.size.height /= 2.0f;
        }
        
        _systemControl = [[CEditBoxImplIOS_objc alloc] initWithFrame:rect editBox:this];
        if (!_systemControl) break;
        
		initInactiveLabels(size);
        setContentSize(size);
		
        return true;
    }while (0);
    
    return false;
}

void CEditBoxImplIOS::initInactiveLabels(const Size& size)
{
	const char* pDefaultFontName = [[_systemControl.textField.font fontName] UTF8String];

	_label = Label::create();
    _label->setAnchorPoint(Vec2(0, 0.5f));
    _label->setColor(Color3B::WHITE);
    _label->setVisible(false);
    _editBox->addChild(_label, kLabelZOrder);
	
    _labelPlaceHolder = Label::create();
	// align the text vertically center
    _labelPlaceHolder->setAnchorPoint(Vec2(0, 0.5f));
    _labelPlaceHolder->setColor(Color3B::GRAY);
    _editBox->addChild(_labelPlaceHolder, kLabelZOrder);
    
    setFont(pDefaultFontName, size.height*2/3);
    setPlaceholderFont(pDefaultFontName, size.height*2/3);
}

void CEditBoxImplIOS::placeInactiveLabels()
{
    _label->setPosition(Vec2(CC_EDIT_BOX_PADDING, _contentSize.height / 2.0f));
    _labelPlaceHolder->setPosition(Vec2(CC_EDIT_BOX_PADDING, _contentSize.height / 2.0f));
}

void CEditBoxImplIOS::setInactiveText(const char* pText)
{
    if(_systemControl.textField.secureTextEntry == YES)
    {
        std::string passwordString;
        for(int i = 0; i < strlen(pText); ++i)
            passwordString.append("\u25CF");
        _label->setString(passwordString.c_str());
    }
    else
        _label->setString(getText());

    // Clip the text width to fit to the text box
    float fMaxWidth = _editBox->getContentSize().width - CC_EDIT_BOX_PADDING * 2;
    Size labelSize = _label->getContentSize();
    if(labelSize.width > fMaxWidth) {
        _label->setDimensions(fMaxWidth,labelSize.height);
    }
}

void CEditBoxImplIOS::setFont(const char* pFontName, int fontSize)
{
    bool isValidFontName = true;
	if(pFontName == NULL || strlen(pFontName) == 0) {
        isValidFontName = false;
    }

    float retinaFactor = _inRetinaMode ? 2.0f : 1.0f;
	NSString * fntName = [NSString stringWithUTF8String:pFontName];

    auto glview = cocos2d::Director::getInstance()->getOpenGLView();

    float scaleFactor = glview->getScaleX();
    UIFont *textFont = nil;
    if (isValidFontName) {
        textFont = [UIFont fontWithName:fntName size:fontSize * scaleFactor / retinaFactor];
    }
    
    if (!isValidFontName || textFont == nil){
        textFont = [UIFont systemFontOfSize:fontSize * scaleFactor / retinaFactor];
    }

	if(textFont != nil) {
		[_systemControl.textField setFont:textFont];
    }

	_label->setSystemFontName(pFontName);
	_label->setSystemFontSize(fontSize);
	_labelPlaceHolder->setSystemFontName(pFontName);
	_labelPlaceHolder->setSystemFontSize(fontSize);
}

void CEditBoxImplIOS::setFontColor(const Color3B& color)
{
    _systemControl.textField.textColor = [UIColor colorWithRed:color.r / 255.0f green:color.g / 255.0f blue:color.b / 255.0f alpha:1.0f];
	_label->setColor(color);
}

void CEditBoxImplIOS::setPlaceholderFont(const char* pFontName, int fontSize)
{
	// TODO need to be implemented.
}

void CEditBoxImplIOS::setPlaceholderFontColor(const Color3B& color)
{
	_labelPlaceHolder->setColor(color);
}

void CEditBoxImplIOS::setInputMode(CEditBox::InputMode inputMode)
{
    switch (inputMode)
    {
        case CEditBox::InputMode::EMAIL_ADDRESS:
            _systemControl.textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case CEditBox::InputMode::NUMERIC:
            _systemControl.textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case CEditBox::InputMode::PHONE_NUMBER:
            _systemControl.textField.keyboardType = UIKeyboardTypePhonePad;
            break;
        case CEditBox::InputMode::URL:
            _systemControl.textField.keyboardType = UIKeyboardTypeURL;
            break;
        case CEditBox::InputMode::DECIMAL:
            _systemControl.textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case CEditBox::InputMode::SINGLE_LINE:
            _systemControl.textField.keyboardType = UIKeyboardTypeDefault;
            break;
        default:
            _systemControl.textField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}

void CEditBoxImplIOS::setMaxLength(int maxLength)
{
    _maxTextLength = maxLength;
}

int CEditBoxImplIOS::getMaxLength()
{
    return _maxTextLength;
}

void CEditBoxImplIOS::setInputFlag(CEditBox::InputFlag inputFlag)
{
    _systemControl.textField.secureTextEntry = NO;
    switch (inputFlag)
    {
        case CEditBox::InputFlag::PASSWORD:
            _systemControl.textField.secureTextEntry = YES;
            break;
        case CEditBox::InputFlag::INITIAL_CAPS_WORD:
            _systemControl.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            break;
        case CEditBox::InputFlag::INITIAL_CAPS_SENTENCE:
            _systemControl.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            break;
        case CEditBox::InputFlag::INTIAL_CAPS_ALL_CHARACTERS:
            _systemControl.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            break;
        case CEditBox::InputFlag::SENSITIVE:
            _systemControl.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            break;
        default:
            break;
    }
}

void CEditBoxImplIOS::setReturnType(CEditBox::KeyboardReturnType returnType)
{
    switch (returnType) {
        case CEditBox::KeyboardReturnType::DEFAULT:
            _systemControl.textField.returnKeyType = UIReturnKeyDefault;
            break;
        case CEditBox::KeyboardReturnType::DONE:
            _systemControl.textField.returnKeyType = UIReturnKeyDone;
            break;
        case CEditBox::KeyboardReturnType::SEND:
            _systemControl.textField.returnKeyType = UIReturnKeySend;
            break;
        case CEditBox::KeyboardReturnType::SEARCH:
            _systemControl.textField.returnKeyType = UIReturnKeySearch;
            break;
        case CEditBox::KeyboardReturnType::GO:
            _systemControl.textField.returnKeyType = UIReturnKeyGo;
            break;
        default:
            _systemControl.textField.returnKeyType = UIReturnKeyDefault;
            break;
    }
}

bool CEditBoxImplIOS::isEditing()
{
    return [_systemControl isEditState] ? true : false;
}

void CEditBoxImplIOS::refreshInactiveText()
{
    const char* text = getText();
    if(_systemControl.textField.hidden == YES)
    {
		setInactiveText(text);
		if(strlen(text) == 0)
		{
			_label->setVisible(false);
			_labelPlaceHolder->setVisible(true);
		}
		else
		{
			_label->setVisible(true);
			_labelPlaceHolder->setVisible(false);
		}
	}
}

void CEditBoxImplIOS::setText(const char* text)
{
    NSString* nsText =[NSString stringWithUTF8String:text];
    if ([nsText compare:_systemControl.textField.text] != NSOrderedSame)
    {
        _systemControl.textField.text = nsText;
    }
    
    refreshInactiveText();
}

NSString* removeSiriString(NSString* str)
{
    NSString* siriString = @"\xef\xbf\xbc";
    return [str stringByReplacingOccurrencesOfString:siriString withString:@""];
}

const char* CEditBoxImplIOS::getText(void)
{
    return [removeSiriString(_systemControl.textField.text) UTF8String];
}

void CEditBoxImplIOS::setPlaceHolder(const char* pText)
{
    _systemControl.textField.placeholder = [NSString stringWithUTF8String:pText];
	_labelPlaceHolder->setString(pText);
}

static CGPoint convertDesignCoordToScreenCoord(const Vec2& designCoord, bool bInRetinaMode)
{
    auto glview = cocos2d::Director::getInstance()->getOpenGLView();
    CCEAGLView *eaglview = (CCEAGLView *) glview->getEAGLView();

    float viewH = (float)[eaglview getHeight];
    
    Vec2 visiblePos = Vec2(designCoord.x * glview->getScaleX(), designCoord.y * glview->getScaleY());
    Vec2 screenGLPos = visiblePos + glview->getViewPortRect().origin;
    
    CGPoint screenPos = CGPointMake(screenGLPos.x, viewH - screenGLPos.y);
    
    if (bInRetinaMode)
    {
        screenPos.x = screenPos.x / 2.0f;
        screenPos.y = screenPos.y / 2.0f;
    }
    CCLOGINFO("[EditBox] pos x = %f, y = %f", screenGLPos.x, screenGLPos.y);
    return screenPos;
}

void CEditBoxImplIOS::setPosition(const Vec2& pos)
{
	_position = pos;
	adjustTextFieldPosition();
}

void CEditBoxImplIOS::setVisible(bool visible)
{
//    _systemControl.textField.hidden = !visible;
}

void CEditBoxImplIOS::setContentSize(const Size& size)
{
    _contentSize = size;
    CCLOG("[Edit text] content size = (%f, %f)", size.width, size.height);
    placeInactiveLabels();
    auto glview = cocos2d::Director::getInstance()->getOpenGLView();
    CGSize controlSize = CGSizeMake(size.width * glview->getScaleX(),size.height * glview->getScaleY());
    
    if (_inRetinaMode)
    {
        controlSize.width /= 2.0f;
        controlSize.height /= 2.0f;
    }
    [_systemControl setContentSize:controlSize];
}

void CEditBoxImplIOS::setAnchorPoint(const Vec2& anchorPoint)
{
    CCLOG("[Edit text] anchor point = (%f, %f)", anchorPoint.x, anchorPoint.y);
	_anchorPoint = anchorPoint;
	setPosition(_position);
}

void CEditBoxImplIOS::visit(void)
{
}

void CEditBoxImplIOS::onEnter(void)
{
    adjustTextFieldPosition();
    const char* pText = getText();
    if (pText) {
        setInactiveText(pText);
    }
}

void CEditBoxImplIOS::updatePosition(float dt)
{
    if (nullptr != _systemControl) {
        this->adjustTextFieldPosition();
    }
}



void CEditBoxImplIOS::adjustTextFieldPosition()
{
	Size contentSize = _editBox->getContentSize();
	Rect rect = Rect(0, 0, contentSize.width, contentSize.height);
    rect = RectApplyAffineTransform(rect, _editBox->nodeToWorldTransform());
	
	Vec2 designCoord = Vec2(rect.origin.x, rect.origin.y + rect.size.height);
    [_systemControl setPosition:convertDesignCoordToScreenCoord(designCoord, _inRetinaMode)];
}

void CEditBoxImplIOS::openKeyboard()
{
	_label->setVisible(false);
	_labelPlaceHolder->setVisible(false);

	_systemControl.textField.hidden = NO;
    [_systemControl openKeyboard];
}

void CEditBoxImplIOS::closeKeyboard()
{
    [_systemControl closeKeyboard];
}

void CEditBoxImplIOS::onEndEditing()
{
	_systemControl.textField.hidden = YES;
	if(strlen(getText()) == 0)
	{
		_label->setVisible(false);
		_labelPlaceHolder->setVisible(true);
	}
	else
	{
		_label->setVisible(true);
		_labelPlaceHolder->setVisible(false);
		setInactiveText(getText());
	}
}

NS_CC_WIDGET_END

#endif /* #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) */


