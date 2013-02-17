-- Imports.
import XMonad
import XMonad.Layout.HintedGrid
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
 
-- The main function.
main = xmonad =<< statusBar toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Main configuration, override the defaults to your liking.
myConfig = defaultConfig { 
    borderWidth = 2
   -- , terminal = "urxvt"
   , terminal = "xfce4-terminal"
--   , modMask = mod4Mask
   , manageHook = manageHook defaultConfig
      <+> composeAll myManagementHooks
      <+> manageDocks
   
   
   }

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
