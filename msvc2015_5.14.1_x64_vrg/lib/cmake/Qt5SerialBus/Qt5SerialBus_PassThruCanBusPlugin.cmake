
add_library(Qt5::PassThruCanBusPlugin MODULE IMPORTED)

set(_Qt5PassThruCanBusPlugin_MODULE_DEPENDENCIES "SerialBus")

foreach(_module_dep ${_Qt5PassThruCanBusPlugin_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
             ${_Qt5SerialBus_FIND_VERSION_EXACT}
            ${_Qt5SerialBus_DEPENDENCIES_FIND_QUIET}
            ${_Qt5SerialBus_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_SerialBus_process_prl_file(
    "${_qt5SerialBus_install_prefix}/plugins/canbus/qtpassthrucanbus.prl" RELEASE
    _Qt5PassThruCanBusPlugin_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5PassThruCanBusPlugin_STATIC_RELEASE_LINK_FLAGS
)


set_property(TARGET Qt5::PassThruCanBusPlugin PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5SerialBus_PassThruCanBusPlugin_Import.cpp"
)

_populate_SerialBus_plugin_properties(PassThruCanBusPlugin RELEASE "canbus/qtpassthrucanbus.lib" FALSE)

list(APPEND Qt5SerialBus_PLUGINS Qt5::PassThruCanBusPlugin)
set_property(TARGET Qt5::SerialBus APPEND PROPERTY QT_ALL_PLUGINS_canbus Qt5::PassThruCanBusPlugin)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_canbus>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_canbus>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::PassThruCanBusPlugin,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::PassThruCanBusPlugin,QT_PLUGIN_EXTENDS>,Qt5::SerialBus>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::PassThruCanBusPlugin,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::PassThruCanBusPlugin,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::PassThruCanBusPlugin>"
)
set_property(TARGET Qt5::SerialBus APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::PassThruCanBusPlugin APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::SerialBus"
)
set_property(TARGET Qt5::PassThruCanBusPlugin PROPERTY QT_PLUGIN_TYPE "canbus")
set_property(TARGET Qt5::PassThruCanBusPlugin PROPERTY QT_PLUGIN_EXTENDS "")
