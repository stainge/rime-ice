require "import"
import "java.io.*"
import "android.widget.*"
import "android.view.*"
import "java.io.File"
import "android.content.Context"
import "com.osfans.trime.*" --载入包
import "android.view.inputmethod.ExtractedTextRequest" --当前光标处内容操作类
import "android.graphics.drawable.GradientDrawable"

import "com.luajava.*"
import "android.graphics.*"
import "android.os.Handler$Callback"
import "android.view.MotionEvent"
import "android.os.Handler"
import "android.widget.AdapterView"
import "java.lang.Runnable"
import "java.lang.Thread"
import "android.os.*"

import "android.graphics.Rect"
import "android.graphics.Color"
import "android.widget.EditText"
import "android.view.WindowManager"
import "com.androlua.LuaDialog"
import "android.view.inputmethod.InputMethodManager"


local Keyboard_height="240dp"
pcall(function()
  Keyboard_height=service.getLastKeyboardHeight()
end)
local Keyboard_width=service.getWidth()
local candidate = this.getCandidateView().getVisibility()--候选栏显示状态
local hide = this.getCandidateView().getHeight()--获取候选栏高度
local phrase_height = Keyboard_height + hide --短语板高度

function 候选栏显示状态()
  if candidate == 0 or candidate == 4 then
    phrase_height = Keyboard_height + hide
    this.getCandidateView().setVisibility(8)
   else
    phrase_height = Keyboard_height
    this.getCandidateView().setVisibility(8)
  end
end

候选栏显示状态()

function pr(t)
  return Toast.makeText(this, tostring(t), 0).show()
end

local default_text_size = 16 -- 字号
local phrase_margin = 20 --间隔
local gn_Padding = 10
local phrase_gn_layout_width = 350  --功能键界面宽度
local phrase_gn_width = phrase_gn_layout_width/2 - 20  --功能键宽度
local phrase_gn_height = phrase_height/4  - phrase_margin --功能键高度

local phrase_itemp_height = phrase_height/6 --单行高

local bot_width = (Keyboard_width - phrase_gn_layout_width)/4 --底部按钮宽度

local 默认 = false  --进入显示界面，默认=true 自定义=false 

local num = 1   --1 显示1列 ，只能设置 1,  2， 设置其他，单双按钮失效

local sw_table = {"默认", "自定义"}  --修改名称后需要 进设置开启


--------------------
local phrase_bj = 0x00D2D1D1 --短语板背景色

local bgColor2 = 0xFFFF8574 --高亮色
--圆角 边框色 边框厚度 卡片背景色
local radius, borderColor, borderWidth, bgColor = 20, 0xFF696969, 1, 0xFFC0A684

local function ColorButton(color)
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setStroke(1, 0xFF696969)
  drawable.setColor(color)
  drawable.setCornerRadius(30)
  return drawable
end

local function ColorButton2(view)
  view.setBackgroundDrawable(ColorButton(bgColor))
end

local backdrawable = ColorButton(bgColor) --卡片背景
local backdrawable2 = ColorButton(bgColor2) --高亮背景
local backdrawableJ = ColorButton(phrase_bj) --剪贴板背景

--高亮
local function highlightButton(button)
  button.BackgroundDrawable = backdrawable2
  local handlerback = Handler(Looper.getMainLooper())
  handlerback.postDelayed(function()
    button.BackgroundDrawable = backdrawable
  end, 300)
end

local function highlightButton2(button, button2)
  button2.setBackgroundDrawable(ColorButton(bgColor2))
  button.setBackgroundDrawable(ColorButton(bgColor))
end

local function 边框()
  -- local 蓝紫 = {0xFFC2E1F3, 0xFFC6B8E2, 0xFF7BB3CA}
  local gd = GradientDrawable()
  -- gd.setColors(蓝紫)
  -- gd.setGradientType(GradientDrawable.LINEAR_GRADIENT) -- 设置线性渐变
  -- gd.setOrientation(GradientDrawable.Orientation["TL_BR"])
  gd.setStroke(1, 0xFF696969)
  gd.setCornerRadius(50)
  -- window.setBackgroundDrawable(gd)
  return gd
end

local currentMode = "双排"
local function toggleSingleDouble(id, id2)
  if phrase_grid.getNumColumns() == 2 then
    id.setNumColumns(1)
    currentMode = "双排"
    id2.setText("双排")
    -- mode = true
   elseif phrase_grid.getNumColumns() == 1 then
    id.setNumColumns(2)
    currentMode = "单排"
    id2.setText("单排")
    -- mode = false
  end
end

local mrname = tostring(sw_table[1])
local zdyname = tostring(sw_table[2])
-- 
local layout =
{
  LinearLayout;
  orientation=0;
  layout_height=phrase_height;
  layout_width=Keyboard_width;
  gravity="center";
  BackgroundDrawable=backdrawableJ,
  {
    LinearLayout;
    orientation=1;
    layout_height="fill";
    layout_weight=1,
    layout_width="fill";
    layout_margin=phrase_margin;
    layout_marginRight="1dp",
    layout_gravity="center";
    gravity="center";
    id="nothing",
    {
      GridView;
      id="phrase_grid";
      layout_width="fill";
      -- layout_height=Keyboard_height;
      gravity="center";
      layout_weight=1,
      -- layout_marginLeft=phrase_margin;
      numColumns=num,
      horizontalSpacing=phrase_margin,
      verticalSpacing=phrase_margin,
      -- fastScrollEnabled=true
    },
    {
      LinearLayout;
      orientation=0;
      layout_height=phrase_itemp_height + 10;
      layout_width="fill";
      -- layout_weight=1,
      id="phrase_bottom_lay",
      layout_gravity="center|bottom";
      gravity="center";
      -- 
      {
        Button;
        id="phrase_add";
        layout_width=bot_width;
        layout_height="fill";
        layout_marginBottom="2dp";
        layout_marginTop="3dp";
        -- layout_marginLeft="5dp";
        layout_gravity="center";
        gravity="center";
        textSize="23sp";
        text="+",
      };
      {
        Button;
        id="phrase_but";
        layout_width=bot_width;
        layout_height="fill";
        layout_marginBottom="2dp";
        layout_marginTop="3dp";
        layout_marginLeft="18dp";
        layout_gravity="center";
        gravity="center";
        textSize="15sp";
        text="双排",
        onClick = function(v)
          toggleSingleDouble(phrase_grid, v)
        end
      };
      {
        Button;
        id="phrase_mr";
        layout_width=bot_width;
        layout_height="fill";
        layout_marginBottom="2dp";
        layout_marginTop="3dp";
        layout_marginLeft="18dp";
        layout_gravity="center";
        gravity="center";
        textSize="15sp";
        text=tostring(mrname),
      };
      {
        Button;
        id="phrase_word";
        layout_width=bot_width;
        layout_height="fill";
        layout_marginBottom="2dp";
        layout_marginTop="3dp";
        layout_marginLeft="18dp";
        layout_gravity="center";
        gravity="center";
        textSize="15sp";
        text=tostring(zdyname),
      };
    },
  };
  {
    LinearLayout;
    orientation=1;
    layout_height="fill";
    layout_width=phrase_gn_layout_width,
    layout_weight=1,
    layout_margin=phrase_margin;
    layout_marginRight="1dp",
    id="phrase_gn_lay",
     gravity="center";
     -- background="#aaec5f67",
  },
}
local layout = loadlayout(layout)

local function gnButtons()
  local phrase_gn_table = {"➥", "⌫", "␣", "√"}
  for i, c in ipairs(phrase_gn_table) do
    local phrase_gn_button = Button(this).setText(c)
    local layoutParams = LinearLayout.LayoutParams(
    phrase_gn_width - gn_Padding,
    phrase_gn_height - gn_Padding
    )
    layoutParams.setMargins(gn_Padding, gn_Padding, gn_Padding, gn_Padding) --边距顺序 左、上、右、下。
    phrase_gn_button.setLayoutParams(layoutParams)
    local gn_lay = LinearLayout(this).setOrientation(1).addView(phrase_gn_button)
    phrase_gn_lay.addView(gn_lay)
    ColorButton2(phrase_gn_button)

    phrase_gn_button.onClick=function(v)
      if c == "➥" then
        返回主键盘()
       elseif c == "⌫" then
        this.onKey(KeyEvent.KEYCODE_DEL, 0)--模拟删除键
       elseif c == "␣" then
        this.onKey(KeyEvent.KEYCODE_SPACE, 0)--模拟空格键
       elseif c == "√" then
        this.onKey(KeyEvent.KEYCODE_ENTER, 0)--模拟回车键
      end
      highlightButton(v)
    end
  end
end

gnButtons()

-- import "com.nirenr.Color"
-- import "android.graphics.Color"
-- import "android.graphics.drawable.shapes.OvalShape"
-- import "android.graphics.drawable.ShapeDrawable"
-- oval_shape=ShapeDrawable(OvalShape()) --按钮颜色圆角
-- oval_shape.getPaint().setColor(bgColor)
-- phrase_but.setBackgroundDrawable(oval_shape)
ColorButton2(phrase_add)
ColorButton2(phrase_but)

local itmep={
  LinearLayout;
  layout_height=phrase_itemp_height,
  layout_width="fill";
  BackgroundDrawable=backdrawable,
  orientation="0";
  gravity="center";
  id="item_but",
  {
    TextView;
    id="num_p";
    layout_width="wrap";
    layout_height="fill",
    layout_gravity="center";
    gravity="center";
    textSize=default_text_size,
    textColor="#ff000000",
    layout_margin="2dp",
    singleLine=true;
    -- background="#aaec5f67",
  };
  {
    TextView;
    id="phrase_itemp_text";
    layout_width="fill";
    layout_height="fill",
    layout_weight="1",
    layout_gravity="center";
    gravity="center";
    textSize=default_text_size,
    textColor="#ff000000",
    layout_margin="2dp",
    singleLine=true;
    -- background="#aaec5f67",
  };
  {
    TextView;
    id="spinner_list";
    layout_height="fill";
    layout_width="wrap";
    layout_marginRight="5dp",
    gravity="center";
    textSize=default_text_size,
    text="🗑️";
    -- background="#aaec5f67",
    -- BackgroundDrawable=边框();
    onClick=function(v)
      local pit = v.getParent().getChildAt(1).getText()
      removeText2(pit)
      print("已删除[ " .. pit .. " ]")
    end
  };

};

local path_rime = service.getLuaExtDir()
local path_phr = path_rime.."/phrase.json"
if not File(path_phr).exists() then
  print(path_phr .. " 不存在")
  -- return nil
end

local phrase_path = debug.getinfo(1,"S").source:sub(2)
local phrase_dir = phrase_path:match("^.*/")
local word_path = phrase_dir .. "/_phrase_word.json"
if not File(word_path).exists() then
  print("创建 " .. word_path .. "……")
  local file = io.open(word_path, "w"):close()
end

local phrase_path_set2 = phrase_dir .. "/_phrase_set.json"

if not File(phrase_path_set2).exists() then
  print("创建 " .. phrase_path_set2 .. "再次进入后刷新设置")
  local file = io.open(phrase_path_set2, "w"):close()
end

local function loadPhrases()
  local path_rime = service.getLuaExtDir()
  local path_phr = path_rime.."/phrase.json"
  local file2 = File(path_phr)
  local mphr = JsonUtil.load(file2)
  local Phrase = luajava.astable(mphr)
  return file2, mphr, Phrase
end

local file2, mphr, Phrase = loadPhrases()

local function loadWordPhrases()
  local phrase_path = debug.getinfo(1,"S").source:sub(2)
  local phrase_dir = phrase_path:match("^.*/")
  local word_path = phrase_dir .. "/_phrase_word.json"
  local word_file = File(word_path)
  local word_json = JsonUtil.load(word_file)
  local word_phrase = luajava.astable(word_json)
  return word_file, word_json, word_phrase
end

local word_file, word_json, word_phrase = loadWordPhrases()

function processPhrases(loadPhrasesFunc)
  local file2, mphr, Phrase = loadPhrasesFunc()
  return Phrase
end

local phrase_data = {}
local adp = LuaAdapter(service, phrase_data, itmep)
phrase_grid.setAdapter(adp)

local handler = Handler(luajava.new(Handler.Callback,{
  handleMessage=function(meg)
    local num = meg.arg1
    local str = tostring(meg.obj)

    table.insert(phrase_data, {
    phrase_itemp_text = str,
    num_p = num ..". "
    })
    if num == mphr.size() then
      adp.notifyDataSetChanged()
    end
    if num == word_json.size() then
      adp.notifyDataSetChanged()
    end
  end
}))

function getMyPhrases(data)
  if(#data==0) then
    pr("=0")
   else
    adp.clear()
    Thread(Runnable({
      run=function()
        for i,n in pairs(data) do
          local mess = handler.obtainMessage()
          mess.arg1 = i
          mess.obj = n
          handler.sendMessage(mess)
        end
      end
    })).start()
  end
end

function getMyPhrases2(Phrase)
  local phrase_data = {}
  local adp = LuaAdapter(service, phrase_data, itmep)
  phrase_grid.setAdapter(adp)
  local function phrase_freshJson(t)
    adp.clear()
    -- phrase_grid.removeAllViews()
    for i, c in ipairs(t) do
      table.insert(phrase_data, {phrase_itemp_text = c})
    end
    adp.notifyDataSetChanged()
  end
  phrase_freshJson(Phrase)
  return adp
end

local function removeText(str,p)
  if 默认 then
    mphr.remove(str)
    adp.remove(p)
    -- service.loadClipboard()
    JsonUtil.save(file2, mphr)
    local file2, mphr, Phrase = loadPhrases()
    -- getMyPhrases(Phrase)
   else
    word_json.remove(str)
    adp.remove(p)
    JsonUtil.save(word_file, word_json)
    -- local word_file, word_json, word_phrase = loadWordPhrases()
    -- getMyPhrases(word_phrase)
  end
  adp.notifyDataSetInvalidated()
end

local function addText(text)
  if 默认 then
    mphr.add(0, text)
    JsonUtil.save(file2, mphr)
    local Phrase = processPhrases(loadPhrases)
    getMyPhrases(Phrase)
   else
    word_json.add(0, text)
    JsonUtil.save(word_file, word_json)
    local word_phrase = processPhrases(loadWordPhrases)
    getMyPhrases(word_phrase)
  end
  -- adp.notifyDataSetChanged()
end

phrase_word.onClick=function(v)
  local word_phrase = processPhrases(loadWordPhrases)
  table.insert(word_phrase, #word_phrase + 1, "+")
  getMyPhrases(word_phrase)

  highlightButton2(phrase_mr,v)

  -- toggleSingleDouble(phrase_grid, phrase_but)
  默认= false
end

phrase_mr.onClick=function(v)
  local Phrase = processPhrases(loadPhrases)
  getMyPhrases(Phrase)
  highlightButton2(phrase_word, v)
  -- phrase_grid.setNumColumns(2)
  -- toggleSingleDouble(phrase_grid, phrase_but)
  默认= true
end

local function getEditorFullText()
  local ExtTextRe= this.getCurrentInputConnection().getExtractedText(ExtractedTextRequest(), 0).text
  return tostring(ExtTextRe)
end

function 设置路径()
  local phrase_path_set = phrase_dir .. "/_phrase_set.json"
  local set_file = File(phrase_path_set)
  local set_json = JsonUtil.load(set_file)
  local set_phrase = luajava.astable(set_json)
  return set_file, set_json, set_phrase
end

-- 初始化存储状态，从配置文件读取
function initStoredStatuses()
  storedStatuses = {}
  local set_file, set_json, set_phrase = 设置路径()
  for i, line in ipairs(set_phrase) do
    local name = line:match("(.-):")
    local status = line:match(": (.+)")
    if name and status then
      storedStatuses[name] = (status == "ON")
    end
  end
  if #set_phrase == 0 then
    stored = {
      [mrname] = "ON",
      [zdyname] = "ON"
    }
    for key, value in pairs(stored) do
      storedStatuses[key] = value
    end
  end
end

-- 检查并更新单个开关的状态
function updateSingleConfig(switchName, isChecked)
  if storedStatuses[switchName] ~= isChecked then
    storedStatuses[switchName] = isChecked
    -- 只有当状态改变时，才更新整个配置文件
    updateFullConfig()
  end
end

function clearFileContent(filePath)
  local file, err = io.open(filePath, "r+")
  if not file then
    print("Error opening file:", err)
    return false
  end
  io.open(filePath,"w"):write(""):close()
  file:close()
  return true
end

-- 更新配置文件，包含所有开关状态
function updateFullConfig()
  clearFileContent(phrase_path_set2)
  local set_file, set_json, set_phrase = 设置路径()
  for switchName, isChecked in pairs(storedStatuses) do
    -- stored_statuses[switchName] = isChecked and "ON" or "OFF"
    local write = switchName .. ": " .. (isChecked and "ON" or "OFF")
    set_json.add(0, write)
    JsonUtil.save(set_file, set_json)
    local read = JsonUtil.read(set_file)
    read.put(switchName, isChecked)
  end
end

-- 在启动时调用初始化函数
initStoredStatuses()

function Phrases_setup()
  local listview = ListView(this)
  local txtview ={
    LinearLayout;
    orientation="horizontal";
    layout_height="50dp";
    layout_width="-1";
    gravity="center";
    {
      Switch;
      id="switch2",
      -- Checked=true,
      -- text="提示",
      Focusable=false,
      layout_height="fill";
      layout_width="fill";
      layout_margin="5dp",
      onClick=function(v)
        local isC = v.isChecked()
        local switchName = v.getText()
        local word_phrase = processPhrases(loadWordPhrases)
        local Phrase = processPhrases(loadPhrases)
        local mr = phrase_mr.getVisibility()
        local word = phrase_word.getVisibility()
        if isC then
          if v.getText() == zdyname then
            word_vsh(word_phrase)
           elseif v.getText() == mrname then
            mr_vsh(Phrase)
          end
         else
          adp.clear()
          if v.getText() == zdyname then
            phrase_word.setVisibility(8)
            if mr ~= 8 then
              mr_vsh(Phrase)
            end
           elseif v.getText() == mrname then
            phrase_mr.setVisibility(8)
            if word ~= 8 then
              word_vsh(word_phrase)
            end
          end
        end

        if mr == 8 and word == 8 then
          adp.clear()
        end

        updateSingleConfig(switchName, isC)
      end
    };
  };
  local layout=LinearLayout(this).setOrientation(1).addView(listview)

  local arradp = LuaAdapter(this, txtview)
  listview.setAdapter(arradp)
  for _, switchName in ipairs(sw_table) do
    local isChecked = storedStatuses[switchName]
    arradp.add({
      switch2 = {
        text = switchName,
        Checked = isChecked
      }
    })
  end
  local SwitchDialog = LuaDialog(this)
  SwitchDialog.setView(layout)
  SwitchDialog.create()
  local window = SwitchDialog.getWindow()
  local lp = window.getAttributes()
  local pixels = -200 --对话框偏移，负数下移
  local displayRect = Rect()
  lp.alpha = 1 --透明度 1完全不透明，0完全透明
  lp.gravity = Gravity.CENTER
  -- lp.gravity = Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL
  lp.y = displayRect.bottom - pixels
  lp.width = 500
  -- lp.height = 450
  window.setAttributes(lp)

  -- 创建并设置背景渐变色
  local 蓝紫 = {0xFFC2E1F3, 0xFFC6B8E2, 0xFF7BB3CA}
  local gd = GradientDrawable()
  gd.setColors(蓝紫)
  gd.setGradientType(GradientDrawable.LINEAR_GRADIENT) -- 设置线性渐变
  gd.setOrientation(GradientDrawable.Orientation["TL_BR"])
  gd.setStroke(1, 0xFF696969)
  gd.setCornerRadius(30)
  window.setBackgroundDrawable(gd)
  SwitchDialog.show()
end

function mr_vsh(Phrase)
  phrase_mr.setVisibility(0)
  getMyPhrases(Phrase)
  highlightButton2(phrase_word, phrase_mr)
end

function word_vsh(word_phrase)
  phrase_word.setVisibility(0)
  getMyPhrases(word_phrase)
  highlightButton2(phrase_mr, phrase_word)
end

local is_mr = storedStatuses[mrname]
local is_word = storedStatuses[zdyname]

if is_mr then
  mr_vsh(Phrase)
 else
  phrase_mr.setVisibility(8)
end

if is_word then
  word_vsh(word_phrase)
 else
  phrase_word.setVisibility(8)
end

if is_mr and is_word then
  if 默认 then
    getMyPhrases(Phrase)
    highlightButton2(phrase_word, phrase_mr)
   else
    getMyPhrases(word_phrase)
    highlightButton2(phrase_mr,phrase_word)
  end
 else
  local data = {"空"}
  getMyPhrases(data)
end



function removeText2(str)
  if 默认 and is_mr then
    mphr.remove(str)
    JsonUtil.save(file2, mphr)
    local file2, mphr, Phrase = loadPhrases()
    getMyPhrases(Phrase)
   else
    word_json.remove(str)
    JsonUtil.save(word_file, word_json)
    local word_file, word_json, word_phrase = loadWordPhrases()
    getMyPhrases(word_phrase)
  end
  adp.notifyDataSetInvalidated()
end

phrase_add.onClick=function(v)
  local pop=PopupMenu(this,v)
  local menu=pop.Menu
  menu.add("添加短语").onMenuItemClick=function(a)
    pop.dismiss()
    if 默认 then
      返回主键盘()
      this.addPhrase()
     else
      编辑框()
    end
  end
  menu.add("添加首条剪贴板内容").onMenuItemClick=function(a)
    local clipBoard = tostring(service.getSystemService(Context.CLIPBOARD_SERVICE).getText())
    if clipBoard == "" then
      print("未检测到剪贴板内容")
     else
      addText(clipBoard)
    end
  end
  menu.add("添加输入框中内容").onMenuItemClick=function(a)
    local Etr = getEditorFullText()
    if Etr ~= "" then
      addText(Etr)
     else
      print("编辑框中未检测到文本")
    end

  end
  menu.add("设置").onMenuItemClick=function(a)
    Phrases_setup()
  end
  pop.show()

  return true
end

function 编辑框()
  local edit = EditText(this)
  local dialog = LuaDialog(this)
  dialog.setTitle("添加自定义短语")
  -- dialog.setMessage("添加")
  dialog.setView(edit)
  dialog.setNegativeButton("取消", nil)
  dialog.setPositiveButton("添加自定义", function(v)
    local text = tostring(edit.getText())
    word_json.add(0, text)
    JsonUtil.save(word_file, word_json)
    dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_MASK_ADJUST)
  end)

  dialog.create()
  local window = dialog.getWindow()
  local lp = window.getAttributes()
  local pixels = -100 --对话框偏移，负数向上
  local displayRect = Rect()
  lp.alpha = 1 --透明度 1完全不透明，0完全透明
  -- lp.gravity = Gravity.CENTER

  lp.gravity = Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL

  lp.y = displayRect.bottom - pixels
  lp.width = 800
  -- lp.height = 450
  window.setAttributes(lp)

  -- 创建并设置背景渐变色
  local gd = GradientDrawable()
  gd.setColors({Color.parseColor("#FFC0A684"), Color.parseColor("#FFC0D0E0"), Color.parseColor("#FFC0D0E0")})
  gd.setGradientType(GradientDrawable.LINEAR_GRADIENT) -- 设置线性渐变
  gd.setOrientation(GradientDrawable.Orientation.TOP_BOTTOM) -- TL_BR对应于TOP_BOTTOM方向

  -- gd.setShape(GradientDrawable.RECTANGLE)
  gd.setStroke(1, 0xFF696969)
  -- gd.setColor(bgColor)
  gd.setCornerRadius(30)
  window.setBackgroundDrawable(gd)
  -- window.BackgroundDrawable = gradientDrawable("TL_BR",{0xFFC0A684, 0xFFc0d0e0, 0xFFc0d0e0},30)
  edit.requestFocus()
  --
  dialog.show()

  window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE|WindowManager.LayoutParams.SOFT_INPUT_ADJUST_UNSPECIFIED );

  -- window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE|WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN)
  -- window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN)

  --打开软键盘（显示输入法）
  -- local imm = this.getSystemService(Context.INPUT_METHOD_SERVICE)
  -- imm.showSoftInput(edit, InputMethodManager.SHOW_IMPLICIT);

  -- local imm = this.getSystemService(Context.INPUT_METHOD_SERVICE)
  -- imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0) -- 强制显示输入法
  返回主键盘()
end

local function PresetKeys__add_phrase()
  Key.presetKeys._add_phrase = {functional = 'true', label = '添加', send = 'function', command = 'add_phrase'}
  service.sendEvent("Keyboard_default")
  service.sendEvent("_add_phrase")
end

phrase_grid.onItemClick=function(l,v,p)
  local text = v.Tag.phrase_itemp_text.Text
  if 默认 then
    service.commitText(text)
   else
    if text == "+" then
      -- pr("编辑")
      编辑框()
      -- PresetKeys__add_phrase()
      -- addEdit()
     else
      service.commitText(text)
    end
  end
end

phrase_grid.onItemLongClick=function(l,v,p,i)
  removeText(v.Tag.phrase_itemp_text.Text, p)
  v.Tag.item_but.setBackgroundDrawable(backdrawable2)
  task(500, function() v.Tag.item_but.setBackgroundDrawable(backdrawable) end)
  return true
end

function 返回主键盘()
  local candidate = this.getCandidateView().getVisibility()
  service.sendEvent("Keyboard_default")
  if candidate == 8 then
    this.getCandidateView().setVisibility(0)
   else
    this.getCandidateView().setVisibility(8)
  end
end


--service.setKeyboard(layout)


return layout


