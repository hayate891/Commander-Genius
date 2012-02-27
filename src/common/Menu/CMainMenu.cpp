/*
 * CMainMenu.cpp
 *
 *  Created on: 19.02.2012
 *      Author: gerstrong
 */

#include "CMainMenu.h"
#include "common/Menu/CMenuController.h"
#include "common/Menu/CSettingsMenu.h"
#include "common/CBehaviorEngine.h"
#include "gui/CGUIButton.h"
#include "core/CGameMode.h"


CMainMenu::CMainMenu( const Uint8 dlgTheme  ) :
CBaseMenu( dlgTheme, CRect<float>(0.25f, 0.24f, 0.5f, 0.5f) )
{
	// Create the Menu Dialog and entries
	mpMenuDialog->setBackground(CGUIDialog::VORTICON);

	CGUIButton *button = new CGUIButton( "New Game", new StartGameplayEvent(), CGUIButton::VORTICON );
	mpMenuDialog->addControl( button, CRect<float>(0.05f, 0.08f, 0.9f, 0.07f) );

	mpMenuDialog->addControl(new CGUIButton( "Settings",
												new OpenMenuEvent( new CSettingsMenu(dlgTheme) ),
												CGUIButton::VORTICON ),
												CRect<float>(0.05f, 0.16f, 0.9f, 0.07f) );

	mpMenuDialog->addControl(new CGUIButton( "Quit", new GMQuit(), CGUIButton::VORTICON ),
												CRect<float>(0.05f, 0.24f, 0.9f, 0.07f) );
}
