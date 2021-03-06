local data = {
	{ tag=1,type="panel",name="panel_welcome",x=372.35,y=240,width=821.45,height=517.45,rotation=0, child={
		{ tag=2,type="button",textSize=16,textFont="fonts/Arial.ttf",red=0,green=0,blue=0,normal="main/btn_ok_normal.png",select="main/btn_ok_select.png",disable="main/btn_ok_disable.png",x=329.35,y=203.35,width=196,height=68,rotation=0,spriteFrame=1},
		{ tag=3,type="controlView",baseboard="main/ctlv_left_baseboard.png",joystick="main/ctlv_left_joystick.png",x=-308.1,y=176.3,width=128,height=128,rotation=0,spriteFrame=0},
		{ tag=4,type="image",image="main/img_bg.png",x=0,y=0,width=480,height=320,scaleX=1,scaleY=1,flipX="1",flipY="1",rotation=0,spriteFrame=0},
		{ tag=5,type="armatureBtn",name="armBtn_test2",normal="normal",select="select",xml="main/armBtn_test2.xml",png="main/armBtn_test2.png",plist="main/armBtn_test2.plist",x=336.35,y=-102.65,width=226,height=349,rotation=0},
		{ tag=6,type="listView",num=10,red=0,green=255,blue=255,alpha=255,x=-209.6,y=-70.2,width=325,height=339.6,rotation=0, child={
			{ tag=8,type="layout",red=0,green=255,blue=255,alpha=0,x=0,y=-134.8,width=325,height=70,rotation=0,spriteFrame=0, child={
				{ tag=9,type="image",image="main/img_itembg.png",x=0,y=0,width=325,height=70,scaleX=1,scaleY=1,flipX="0",flipY="0",rotation=0,spriteFrame=0},
				{ tag=10,type="button",textSize=16,textFont="fonts/Arial.ttf",red=0,green=0,blue=0,normal="main/btn_pay_normal.png",select="main/btn_pay_select.png",disable="main/btn_pay_disable.png",x=109.35,y=1,width=70,height=36,rotation=0,spriteFrame=0},
			}},
		}},
		{ tag=11,type="numStep",lnormal="main/numStep_test_lnomal.png",lselect="main/numStep_test_lselect.png",ldisable="main/numStep_test_ldisable.png",rnormal="main/numStep_test_rnomal.png",rselect="main/numStep_test_rselect.png",rdisable="main/numStep_test_rdisable.png",stepBg="main/numStep_test_stepbg.png",max=100,min=0,cur=15,x=163,y=215.35,width=69,height=17,rotation=0,spriteFrame=0,longClickRun="1",step="1"},
		{ tag=12,type="armature",name="armature_boss1",xml="main/armature_boss1.xml",png="main/armature_boss1.png",plist="main/armature_boss1.plist",x=76.9,y=111.05,width=407,height=374,rotation=0,play="live"},
		{ tag=13,type="particle",plist="main/ptl_flower.plist",x=146,y=-169.65,width=24,height=35,rotation=0,spriteFrame=0},
		{ tag=14,type="label",text="hello world",alignment=0,textSize=20,textFont="fonts/Arial.ttf",red=255,green=0,blue=0,strokeRed=0,strokeGreen=0,strokeBlue=0,strokeSize=0,shadowDistance=0,shadowBlur=0,x=113,y=119.85,width=108,height=29.15,rotation=0},
		{ tag=15,type="toggleView",normal="main/tgv_option_normal.png",select="main/tgv_option_select.png",disable="main/tgv_option_disable.png",exclusion="-1",x=-8.4,y=187.95,width=221,height=89,rotation=0,spriteFrame=0},
		{ tag=16,type="checkBox",normal1="main/ckb_test_normal1.png",select1="main/ckb_test_select1.png",disable1="main/ckb_test_disable1.png",normal2="main/ckb_test_normal2.png",select2="main/ckb_test_select2.png",disable2="main/ckb_test_disable2.png",x=-174.95,y=194.45,width=56,height=56,rotation=0,spriteFrame=0},
		{ tag=17,type="editBox",placeHolder="请输入字符",image="main/edit_login.png",inputMode=0,inputFlag=4,x=43,y=-209.5,width=162,height=35,rotation=0,spriteFrame=0},
		{ tag=18,type="label",text="这是中文",alignment=0,textSize=20,textFont="fonts/Arial.ttf",red=0,green=0,blue=255,strokeRed=255,strokeGreen=255,strokeBlue=255,strokeSize=2,shadowDistance=0,shadowBlur=0,x=124,y=157,width=104,height=26.35,rotation=0},
		{ tag=19,type="label",text="这是阴影",alignment=0,textSize=20,textFont="fonts/Arial.ttf",red=255,green=255,blue=0,strokeRed=0,strokeGreen=0,strokeBlue=0,strokeSize=0,shadowDistance=2,shadowBlur=5,x=158.5,y=-48.65,width=104,height=26.35,rotation=0},
		{ tag=20,type="button",textSize=16,textFont="fonts/Arial.ttf",red=0,green=0,blue=0,normal="main/btn_ok_normal.png",select="main/btn_ok_select.png",disable="main/btn_ok_disable.png",x=329.35,y=135.35,width=196,height=68,rotation=0,spriteFrame=1},
		{ tag=21,type="button",textSize=16,textFont="fonts/Arial.ttf",red=0,green=0,blue=0,normal="main/btn_ok_normal.png",select="main/btn_ok_select.png",disable="main/btn_ok_disable.png",x=329.5,y=67.35,width=196,height=68,rotation=0,spriteFrame=1},
		{ tag=22,type="anim",name="anim_coin",png="main/anim_coin.png",plist="main/anim_coin.plist",x=-121.15,y=103.05,width=37,height=45,rotation=0,playTime="0.1",isLoop="false"},
	}},
	{ tag=23,type="panel",name="panel_msgbox",x=400,y=240,width=621.45,height=273.5,rotation=0, child={
		{ tag=24,type="image9",image="main/dialog/img9_boxbg.png",up="20",down="20",left="20",right="20",x=0,y=0,width=619.65,height=268.15,rotation=0,spriteFrame=0},
		{ tag=25,type="button",textSize=16,textFont="fonts/Arial.ttf",red=0,green=0,blue=0,normal="main/dialog/btn_close_normal.png",select="main/dialog/btn_close_select.png",disable="main/dialog/btn_close_disable.png",x=280,y=-103,width=68,height=73,rotation=0,spriteFrame=0},
		{ tag=26,type="labelAtlas",num=123456,image="main/dialog/labAtlas_num.png",x=0,y=0,width=312,height=34,rotation=0,spriteFrame=0},
		{ tag=27,type="slider",bg="main/dialog/slider_test_bg.png",progress="main/dialog/slider_test_progress.png",thumb="main/dialog/slider_test_thumb.png",max=100,min=0,cur=15,x=0,y=61.45,width=500,height=52,rotation=0,spriteFrame=0},
		{ tag=28,type="progress",bg="main/dialog/prog_hp_bg.png",progress="main/dialog/prog_hp_progress.png",max=100,min=0,cur=15,showLabel=1,x=0,y=99.95,width=300,height=23,rotation=0,spriteFrame=0},
		{ tag=29,type="labelBMFont",text="美好的一天123456789______________\nzeeeeeeeerrrjoaienroicf : )",fnt="main/dialog/labBmf_test.fnt",x=-241.5,y=-92.65,width=512,height=76.8,rotation=0},
	}},

}
local controls = {}
function controls.getAllControls()
    return data
end

function controls.getControl(id)
    return data[id]
end

local findNodeByTag
findNodeByTag = function (node, tag)
    for i,v in ipairs(node) do
        if v.tag == tag then
            return node[i]
        end
        if v.child ~= nil then
        	local t = findNodeByTag(v.child, tag)
        	if t ~= nil then return t end
        end
    end
    return nil
end

function controls.getControlByTag(tag)
	return findNodeByTag(data, tag)
end

return controls