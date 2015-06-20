{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Config.Xfce
import XMonad.Actions.CycleWS

import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

import qualified Data.Map as M
import qualified XMonad.StackSet as W

main = xmonad myXfceConfig

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myXfceConfig = xfceConfig
    { terminal           = "urxvt"
    , keys               = myKeys
    , normalBorderColor  = "#222222"
    , focusedBorderColor = "#444444"
    --, handleEventHook    = ewmhDesktopsEventHook
    , startupHook        = ewmhDesktopsStartup <+> setWMName "LG3D"
    , workspaces         = myWorkspaces
    , manageHook         = myManageHook <+> manageHook xfceConfig
    , handleEventHook    = fullscreenEventHook
    }

myManageHook = composeAll $
               [ isFullscreen --> doFullFloat
               , className =? "Xfce4-panel" --> doIgnore
               ]

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- launch a terminal
    [ ((mod4Mask, xK_Return), spawn $ XMonad.terminal conf)
 
    -- launch "run application"
    , ((mod4Mask, xK_r ), spawn "gmrun")
 
    -- launch emacs
    , ((mod4Mask, xK_e), spawn "emacs")

    -- launch browser
    , ((mod4Mask, xK_f), spawn "google-chrome")
    
    -- launch mail
    , ((mod4Mask, xK_m), spawn "claws-mail")

    -- launch banshee
    , ((mod4Mask, xK_b), spawn "pragha")

    -- launch pidgin
    , ((mod4Mask, xK_g), spawn "pidgin")
 
    -- close focused window 
    , ((mod4Mask, xK_c), kill)
    
    -- close focused window 
    , ((mod4Mask, xK_k), spawn "xkill")

    -- Restart xmonad
    , ((mod4Mask, xK_q), spawn "xmonad --recompile && xmonad --restart")
 
    -- Rotate through the available layout algorithms
    , ((mod4Mask, xK_space), sendMessage NextLayout)
 
    -- Resize viewed windows to the correct size
    , ((mod4Mask, xK_n), refresh)

    -- Move focus to the next window
    , ((mod4Mask, xK_Tab), windows W.focusDown)
 
    -- Swap the focused window and the master window
    , ((mod4Mask, xK_BackSpace), windows W.swapMaster)
 
    -- Shrink the master area
    , ((mod4Mask, xK_Left), sendMessage Shrink)
 
    -- Expand the master area
    , ((mod4Mask, xK_Right), sendMessage Expand)
 
    -- Push window back into tiling
    , ((mod4Mask, xK_Home), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((mod4Mask, xK_Up), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((mod4Mask, xK_Down), sendMessage (IncMasterN (-1)))

    -- Cycle through xinerama screens
    , ((mod4Mask, xK_quoteleft), nextScreen)

    -- Cycle through xinerama screens
    , ((mod4Mask .|. shiftMask , xK_quoteleft), swapNextScreen)

    ]
    ++
 
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. mod4Mask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
