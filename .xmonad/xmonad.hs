-- Sources:
-- Workspace cycling http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Actions-CycleWS.html
-- adding keymaps rather than replacing http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Doc-Extending.html#Editing_the_layout_hook
-- Fading inactive windows http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-FadeInactive.html
-- Default XmonadConfig http://xmonad.org/xmonad-docs/xmonad/src/XMonad-Config.html (or in this directory for convenience)
-- Interesting overview http://thinkingeek.com/2011/11/21/simple-guide-configure-xmonad-dzen2-conky/
-- EZConfig http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html#v:removeKeys

-- Imports.
import XMonad
-- import XMonad.Layout.HintedGrid
import XMonad.Layout.Grid
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import qualified Data.Map as M
import XMonad.Actions.CycleWS
import XMonad.Hooks.FadeInactive
import XMonad.Config.Xfce
-- import XMonad.Util.EZConfig

main = xmonad myConfig 

-- Main configuration, override the defaults to your liking.
myConfig = xfceConfig { 
    borderWidth = 4 
   , focusedBorderColor = "#000000"
   , normalBorderColor = "#000000"
   -- , terminal = "urxvt"
   , terminal = "xfce4-terminal"
--   , modMask = mod4Mask
   , manageHook = manageHook defaultConfig
      <+> composeAll myManagementHooks
      <+> manageDocks
   , keys= myKeys <+> keys defaultConfig 
   , logHook = myLogHook
   }

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
     -- /usr/include/X11/keysymdef.h
    [
     -- Key binding to toggle the gap for the bar.
     ((modMask, xK_b), sendMessage ToggleStruts)
    , ((modMask .|. shiftMask, xK_q), spawn "xfce4-session-logout")
    -- instead of dmenu i'm using Synapse, also bound to ctrl-p
    , ((modMask, xK_p), return ()) 
--    , ((modMask,               xK_p     ), spawn "dmenu_run") -- %! Launch dmenu
    -- , ((modMask , xK_s     ), spawn "xflock")   
    , ((modMask .|. shiftMask, xK_Print), spawn "~/bin/screencap_selection.sh") 
   -- a basic CycleWS setup
   , ((modMask .|. controlMask, xK_Down),  nextWS)
   , ((modMask .|. controlMask, xK_Up),    prevWS)
   , ((modMask .|. shiftMask, xK_Down),  shiftToNext)
   , ((modMask .|. shiftMask, xK_Up),    shiftToPrev)
   , ((modMask,               xK_Right), nextScreen)
   , ((modMask,               xK_Left),  prevScreen)
   , ((modMask .|. shiftMask, xK_Right), shiftNextScreen)
   , ((modMask .|. shiftMask, xK_Left),  shiftPrevScreen)
   , ((modMask,               xK_z),     toggleWS)
   -- Alt-Shift ` , ask X to fix its resolution (useful for when unplugging monitors..)
   , ((modMask .|. shiftMask, xK_grave), spawn "/usr/bin/xrandr --auto")
    ]


myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 0.90
 
myManagementHooks :: [ManageHook]
myManagementHooks = [
  resource =? "synapse" --> doIgnore
  , resource =? "stalonetray" --> doIgnore
  , className =? "rdesktop" --> doFloat
 -- , (className =? "Komodo IDE") --> doF (W.shift "5:Dev")
 -- , (className =? "Komodo IDE" <&&> resource =? "Komodo_find2") --> doFloat
--  , (className =? "Komodo IDE" <&&> resource =? "Komodo_gotofile") --> doFloat
 -- , (className =? "Komodo IDE" <&&> resource =? "Toplevel") --> doFloat
 -- , (className =? "Empathy") --> doF (W.shift "7:Chat")
 -- , (className =? "Pidgin") --> doF (W.shift "7:Chat")
 -- , (className =? "Gimp-2.8") --> doF (W.shift "9:Pix")
  ]

-- Based on config layout
layout = tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 5/100
