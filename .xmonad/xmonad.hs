-- Sources:
-- Workspace cycling http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Actions-CycleWS.html
-- adding keymaps rather than replacing http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Doc-Extending.html#Editing_the_layout_hook
-- Fading inactive windows http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-FadeInactive.html
-- Default XmonadConfig http://xmonad.org/xmonad-docs/xmonad/src/XMonad-Config.html (or in this directory for convenience)
-- Interesting overview http://thinkingeek.com/2011/11/21/simple-guide-configure-xmonad-dzen2-conky/
-- EZConfig http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html#v:removeKeys
-- Adam's cool config https://github.com/adampetrovic/xmonad-dotfiles/blob/laptop/xmonad.hs
--
-- ~/.xmonad/xmonad.hs
-- Imports {{{
import XMonad
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)
-- Hooks
import XMonad.Operations

import System.IO
import System.Exit

import XMonad.Util.Run

import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn
import XMonad.Actions.OnScreen

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Reflect
import XMonad.Layout.Grid
import XMonad.Layout.ThreeColumns

import Data.Ratio ((%))

import qualified XMonad.StackSet as W
import qualified Data.Map as M

--}}}

-- Config {{{
-- Define Terminal
myTerminal      = "urxvt"
-- Define modMask
modMask' :: KeyMask
modMask' = mod1Mask
-- Define workspaces
myWorkspaces    = ["1:web","2:dev","3:media","4","5:chat","6:vm", "7", "8", "9:music"]
-- Dzen config
-- myStatusBar = "dzen2 -h '24' -w '1240' -ta 'l' -fg '#FFFFFF' -bg '#161616' -fn '-*-bitstream vera sans-medium-r-normal-*-11-*-*-*-*-*-*-*'"
myStatusBar = "dzen2 -h '24' -w '1200' -ta 'l' -fg '#FFFFFF' -bg '#161616'" 
-- myBtmStatusBar = "conky -c /home/beto/.xmonad/conky_bottom_dzen | dzen2 -w '1366' -h '24' -y '768' -ta 'c' -bg '#161616' -fg '#FFFFFF' -fn '-*-bitstream vera sans-medium-r-normal-*-11-*-*-*-*-*-*-*'"
myBtmStatusBar = "conky -c /home/beto/.xmonad/conky_bottom_dzen | dzen2 -w '1366' -h '20' -y '748' -ta 'c' -bg '#161616' -fg '#FFFFFF' "
myBitmapsDir = "/home/beto/.xmonad/dzen"
--}}}
-- Main {{{
main = do
    dzenTopBar <- spawnPipe myStatusBar
    dzenBtmBar <- spawnPipe myBtmStatusBar
    spawn "sh /home/beto/bin/x_start_apps.sh"
    xmonad $ defaultConfig
      { terminal            = myTerminal
      , workspaces          = myWorkspaces
      , keys                = keys'
      , modMask             = modMask'
      , startupHook         = myStartupHook 
      , layoutHook          = smartBorders $ layoutHook'
      , manageHook          = manageHook'
      , logHook             = myLogHook dzenTopBar >> fadeInactiveLogHook 0xdddddddd  >> setWMName "Screen1"
      , normalBorderColor   = colorNormalBorder
      , focusedBorderColor  = colorFocusedBorder
}
--}}}


-- Hooks {{{
--
-- StartupHook {{{
myStartupHook = do
    windows (greedyViewOnScreen 0 "2:dev");

--    spawnOn "1:web" "google-chrome";
--    spawnOn "5:chat" "pidgin";
-- }}}

-- ManageHook {{{
manageHook' :: ManageHook
manageHook' = (composeAll . concat $
    [ [resource     =? r            --> doIgnore            |   r   <- myIgnores] -- ignore desktop
    , [className    =? c            --> doShift  "1:web"   |   c   <- myWebs   ] -- move web to web
    , [className    =? c            --> doShift  "3:media"  |   c   <- myMovie   ] -- move movie to movie
    , [className    =? c            --> doShift  "4"  |   c   <- myMusic   ] -- move music to music
    , [className    =? c            --> doShift  "5:chat"   |   c   <- myChat  ] -- move chat to chat
    , [className    =? c            --> doShift  "6:vm"   |   c   <- myVm  ] -- move vm to vm 
    , [className    =? c            --> doCenterFloat       |   c   <- myFloats ] -- float my floats
    , [name         =? n            --> doCenterFloat       |   n   <- myNames  ] -- float my names
    , [isFullscreen                 --> myDoFullFloat                           ]
    ]) 

    where

        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"

        -- classnames
        myFloats  = ["Smplayer","MPlayer","Xmessage","Save As...","XFontSel","Downloads","Nm-connection-editor"]
        myWebs    = ["Navigator","Shiretoko","Firefox","Uzbl","uzbl","Uzbl-core","uzbl-core","Google-chrome","Chromium","Shredder","Mail"]
        myMovie   = ["Boxee", "vlc", "Vlc", "vlc-main", "VLC media player"]
        myMusic   = ["Rhythmbox","Clementine","Tomahawk","Banshee","Banshee Media Player","banshee-1","Exaile","Spotify"]
        myChat    = ["Pidgin","Buddy List"]
        myVm = ["VirtualBox"]

        -- resources
        myIgnores = ["desktop","desktop_window","notify-osd","stalonetray","trayer"]

        -- names
        myNames   = ["bashrun","Google Chrome Options","Chromium Options"]

-- a trick for fullscreen but stil allow focusing of other WSs
myDoFullFloat :: ManageHook
myDoFullFloat = doF W.focusDown <+> doFullFloat
-- }}}

-- myTermHook - this is a trick that lets you spawn a new urxvt window to the same PWD if the current window is pwd
myTerm = withWindowSet $ \w -> maybe defaultAction f (W.peek w)
         where f :: Window -> X()
               f w = do
                 c <- runQuery appName w
                 t <- runQuery title w
                 let ts = words t
                     titleWords = length ts
                     -- We assume a specific title format:  username (pwd) [dimension]
                     -- , which is controlled by $PS1 in ~/.zer0prompt
                     pwdLength = length $ ts!!1
                     -- pwd = init pwd'
                     (x:user') = ts!!0
                     initUser = init user'
                     lastUser = last user'
                     pwd = ts!!1
                 -- It's possible that urxvt's title has been changed by the process running inside
                 if c /= "urxvt" || titleWords /= 2 || pwdLength < 3 || lastUser /= ':' then defaultAction
                  else spawn $ term ++ " -cd " ++ pwd

               -- Arch packages (e.g. wget, pacman) often have trouble with Chinese locales.
               term = "LANG=en_US.utf8 urxvt"
               defaultAction = spawn term

-- layoutHook' = customLayout
layoutHook'  =  onWorkspaces ["2:dev", "4"] customLayout3 $ onWorkspaces ["5:chat"] imLayout $ 
                customLayout2
-- Bar
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "#ebac54" "#161616" . pad
      , ppVisible           =   dzenColor "white" "#161616" . pad
      , ppHidden            =   dzenColor "white" "#161616" . pad
      , ppHiddenNoWindows   =   dzenColor "#444444" "#161616" . pad
      , ppUrgent            =   dzenColor "red" "#161616" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor "#ebac54" "#161616" .
                                (\x -> case x of
                                    "Spacing 5 ResizableTall"   ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror Spacing 5 ResizableTall"->  "Mirror"
                                    "Mirror ResizableTall"      ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full"                      ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    --"Simple Float"              ->      "~"
                                    _                           ->      x
                                )
      , ppTitle             =   (" " ++) . dzenColor "white" "#161616" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }
-- Layout
customLayout = gaps [(D,2)] $ avoidStruts $ smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full
  where
--    tiled = ResizableTall 1 (2/100) (1/2) []
      tiled   = spacing pxl $ ResizableTall 1 (2/100) (1/2) []
--    nmaster = 1   
--    delta   = 2/100
--    ratio   = 1/2
      pxl     = 2 

customLayout2 = avoidStruts $ noBorders Full ||| smartBorders tiled ||| smartBorders (Mirror tiled)
  where
    --tiled = ResizableTall 1 (2/100) (1/2) []
    tiled   = spacing pxl $ ResizableTall nmaster delta ratio []
    nmaster = 1   
    delta   = 2/100
    ratio   = 1/2
    pxl     = 2

customLayout3 = avoidStruts $ smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full
  where
--    tiled = ResizableTall 1 (2/100) (1/2) []
      tiled   = spacing pxl $ ResizableTall 1 (2/100) (1/2) []
--    nmaster = 1   
--    delta   = 2/100
--    ratio   = 1/2
      pxl     = 2

imLayout    = avoidStruts $ withIM (1%5) (And (ClassName "Pidgin") (Role "buddy_list")) Grid 
--  where
--    tiled   = spacing pxl $ ResizableTall 1 (2/100) (1/2) []
--    nmaster = 1
--    delta   = 2/100
--    ratio   = 1/2
--    pxl     = 5
--}}}
-- Theme {{{
-- Color names are easier to remember:
colorOrange          = "#ff7701"
colorDarkGray        = "#171717"
colorPink            = "#e3008d"
colorGreen           = "#00aa4a"
colorBlue            = "#008dd5"
colorYellow          = "#fee100"
colorWhite           = "#cfbfad"
 
colorNormalBorder    = "#1c2636"
colorFocusedBorder   = "#ebac54"
--}}}

-- Key mapping {{{
keys' :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    ----------------------------------------------------------------------
  -- Custom key bindings
  --  

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask .|. shiftMask, xK_Return),
     myTerm)

  -- Lock the screen using xscreensaver.
  --, ((modMask .|. controlMask, xK_l),
  , ((modMask .|. controlMask, xK_s),
     spawn "xscreensaver-command --lock")

  -- Launch dmenu via yeganesh.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_p),
     spawn "dmenu_run -l 8 -nb \"#1B1D1E\" -nf \"#a0a0a0\" -sb \"#333\" -sf \"#fff\" -p Command: -b")

  -- Take a screenshot in select mode.
  -- After pressing this key binding, click a window, or draw a rectangle with
  -- the mouse.
--  , ((modMask .|. shiftMask, xK_p),
--     spawn "select-screenshot")

  -- Take full screenshot in multi-head mode.
  -- That is, take a screenshot of everything you see.
--  , ((modMask .|. controlMask .|. shiftMask, xK_p),
--     spawn "screenshot")

  -- Mute volume.
  , ((0, 0x1008FF12),
     spawn "amixer -q set Master toggle")

  -- Decrease volume.
  , ((0, 0x1008FF11),
     spawn "amixer -q set Master 10%-")

  -- Increase volume.
  , ((0, 0x1008FF13),
     spawn "amixer -q set Master 10%+")

  -- Audio previous.
  , ((0, 0x1008FF16),
     spawn "") 

  -- Play/pause.
  , ((0, 0x1008FF14),
     spawn "") 

  -- Audio next.
  , ((0, 0x1008FF17),
     spawn "") 

  -- Eject CD tray.
  , ((0, 0x1008FF2C),
     spawn "eject -T")

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --  

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n),
     refresh)

  -- Move focus to the next window.
  , ((modMask, xK_Tab),
     windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k),
     windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q),
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q),
     restart "xmonad" True)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_KP_Home, xK_KP_Left, xK_KP_Begin, xK_KP_Right, xK_KP_Page_Up] [4,0,1,2,3]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

--}}}
-- vim:foldmethod=marker sw=4 sts=4 ts=4 tw=0 et ai nowrap
