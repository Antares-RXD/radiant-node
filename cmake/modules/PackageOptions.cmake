# Package options
set(CPACK_PACKAGE_VENDOR "${COPYRIGHT_HOLDERS_FINAL}")
set(CPACK_PACKAGE_DESCRIPTION "Bitcoin Cash Node is a Bitcoin Cash full node implementation.")
set(CPACK_PACKAGE_HOMEPAGE_URL "${PROJECT_HOMEPAGE_URL}")
set(CPACK_PACKAGE_CONTACT "info@bitcoincashnode.org")

set(CPACK_PACKAGE_INSTALL_DIRECTORY "Bitcoin-Cash-Node")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/COPYING")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/doc/README_windows.txt")

if(CMAKE_CROSSCOMPILING)
	set(CPACK_SYSTEM_NAME "${TOOLCHAIN_PREFIX}")
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/share/pixmaps/nsis-header.bmp")
	set(CPACK_GENERATOR "NSIS;ZIP")
	set(CPACK_INSTALLED_DIRECTORIES "${CMAKE_SOURCE_DIR}/doc" doc)
else()
	set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/share/pixmaps/bitcoin128.png")
	set(CPACK_GENERATOR "TGZ")
endif()

# Prevent the components aware generators (such as ZIP) from generating a
# different package for each component.
set(CPACK_MONOLITHIC_INSTALL ON)

# CPack source package options
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")
set(CPACK_SOURCE_GENERATOR "TGZ")

# CPack NSIS installer options
Include(InstallationHelper)
set(CPACK_NSIS_EXECUTABLES_DIRECTORY "${CMAKE_INSTALL_BINDIR}")
set(_nsis_bitcoin_qt "bitcoin-qt.exe")

set(CPACK_NSIS_URL_INFO_ABOUT "${CPACK_PACKAGE_HOMEPAGE_URL}")
set(CPACK_NSIS_CONTACT "${CPACK_PACKAGE_CONTACT}")

set(CPACK_NSIS_MUI_ICON "${CMAKE_SOURCE_DIR}/share/pixmaps/bitcoin.ico")
set(CPACK_NSIS_MUI_UNIICON "${CPACK_NSIS_MUI_ICON}")
set(CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP "${CMAKE_SOURCE_DIR}/share/pixmaps/nsis-wizard.bmp")
set(CPACK_NSIS_MUI_UNWELCOMEFINISHPAGE_BITMAP "${CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP}")
set(CPACK_NSIS_MUI_FINISHPAGE_RUN "${_nsis_bitcoin_qt}")
set(CPACK_NSIS_INSTALLED_ICON_NAME "${CMAKE_INSTALL_BINDIR}/${_nsis_bitcoin_qt}")

set(CPACK_NSIS_COMPRESSOR "/SOLID lzma")
set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
set(CPACK_NSIS_DISPLAY_NAME "${PACKAGE_NAME}")

macro(add_start_menu_link LINK_NAME EXE PARAMETERS ICON_EXE ICON_INDEX)
	list(APPEND CPACK_NSIS_CREATE_ICONS_EXTRA
		"CreateShortCut '$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\${LINK_NAME}.lnk' '$INSTDIR\\\\${CMAKE_INSTALL_BINDIR}\\\\${EXE}' '${PARAMETERS}' '$INSTDIR\\\\${CMAKE_INSTALL_BINDIR}\\\\${ICON_EXE}' '${ICON_INDEX}'"
	)
	list(APPEND CPACK_NSIS_DELETE_ICONS_EXTRA
		"Delete '$SMPROGRAMS\\\\$START_MENU\\\\${LINK_NAME}.lnk'"
	)
endmacro()

set(CPACK_NSIS_MENU_LINKS "${CMAKE_INSTALL_BINDIR}/${_nsis_bitcoin_qt}" "Bitcoin Cash Node")
add_start_menu_link("${PACKAGE_NAME} (testnet)"
	"${_nsis_bitcoin_qt}"
	"-testnet"
	"${_nsis_bitcoin_qt}"
	1
)
