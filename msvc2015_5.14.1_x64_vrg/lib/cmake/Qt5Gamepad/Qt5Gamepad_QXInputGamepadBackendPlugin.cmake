
add_library(Qt5::QXInputGamepadBackendPlugin MODULE IMPORTED)

set(_Qt5QXInputGamepadBackendPlugin_MODULE_DEPENDENCIES "Gamepad;Gamepad;Gui;Core")

foreach(_module_dep ${_Qt5QXInputGamepadBackendPlugin_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
             ${_Qt5Gamepad_FIND_VERSION_EXACT}
            ${_Qt5Gamepad_DEPENDENCIES_FIND_QUIET}
            ${_Qt5Gamepad_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_Gamepad_process_prl_file(
    "${_qt5Gamepad_install_prefix}/plugins/gamepads/xinputgamepad.prl" RELEASE
    _Qt5QXInputGamepadBackendPlugin_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QXInputGamepadBackendPlugin_STATIC_RELEASE_LINK_FLAGS
)


set_property(TARGET Qt5::QXInputGamepadBackendPlugin PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Gamepad_QXInputGamepadBackendPlugin_Import.cpp"
)

_populate_Gamepad_plugin_properties(QXInputGamepadBackendPlugin RELEASE "gamepads/xinputgamepad.lib" FALSE)

list(APPEND Qt5Gamepad_PLUGINS Qt5::QXInputGamepadBackendPlugin)
set_property(TARGET Qt5::Gamepad APPEND PROPERTY QT_ALL_PLUGINS_gamepads Qt5::QXInputGamepadBackendPlugin)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_gamepads>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_gamepads>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QXInputGamepadBackendPlugin,${_manual_plugins_genex};${_plugin_type_genex}>"
)
string(CONCAT _plugin_genex
    "$<$<OR:"
        # Add this plugin if it's in the list of manual plugins or plugins for the type
        "${_user_specified_genex},"
        # Add this plugin if the list of plugins for the type is empty, the PLUGIN_EXTENDS
        # is either empty or equal to the module name, and the user hasn't blacklisted it
        "$<AND:"
            "$<STREQUAL:${_plugin_type_genex},>,"
            "$<OR:"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QXInputGamepadBackendPlugin,QT_PLUGIN_EXTENDS>,Qt5::Gamepad>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QXInputGamepadBackendPlugin,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QXInputGamepadBackendPlugin,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QXInputGamepadBackendPlugin>"
)
set_property(TARGET Qt5::Gamepad APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QXInputGamepadBackendPlugin APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Gamepad;Qt5::Gamepad;Qt5::Gui;Qt5::Core"
)
set_property(TARGET Qt5::QXInputGamepadBackendPlugin PROPERTY QT_PLUGIN_TYPE "gamepads")
set_property(TARGET Qt5::QXInputGamepadBackendPlugin PROPERTY QT_PLUGIN_EXTENDS "")
