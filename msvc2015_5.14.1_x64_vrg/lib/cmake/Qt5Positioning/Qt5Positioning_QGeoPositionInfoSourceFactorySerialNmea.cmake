
add_library(Qt5::QGeoPositionInfoSourceFactorySerialNmea MODULE IMPORTED)

set(_Qt5QGeoPositionInfoSourceFactorySerialNmea_MODULE_DEPENDENCIES "Positioning;Core;SerialPort")

foreach(_module_dep ${_Qt5QGeoPositionInfoSourceFactorySerialNmea_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
             ${_Qt5Positioning_FIND_VERSION_EXACT}
            ${_Qt5Positioning_DEPENDENCIES_FIND_QUIET}
            ${_Qt5Positioning_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_Positioning_process_prl_file(
    "${_qt5Positioning_install_prefix}/plugins/position/qtposition_serialnmea.prl" RELEASE
    _Qt5QGeoPositionInfoSourceFactorySerialNmea_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QGeoPositionInfoSourceFactorySerialNmea_STATIC_RELEASE_LINK_FLAGS
)


set_property(TARGET Qt5::QGeoPositionInfoSourceFactorySerialNmea PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Positioning_QGeoPositionInfoSourceFactorySerialNmea_Import.cpp"
)

_populate_Positioning_plugin_properties(QGeoPositionInfoSourceFactorySerialNmea RELEASE "position/qtposition_serialnmea.lib" FALSE)

list(APPEND Qt5Positioning_PLUGINS Qt5::QGeoPositionInfoSourceFactorySerialNmea)
set_property(TARGET Qt5::Positioning APPEND PROPERTY QT_ALL_PLUGINS_position Qt5::QGeoPositionInfoSourceFactorySerialNmea)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_position>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_position>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QGeoPositionInfoSourceFactorySerialNmea,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QGeoPositionInfoSourceFactorySerialNmea,QT_PLUGIN_EXTENDS>,Qt5::Positioning>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QGeoPositionInfoSourceFactorySerialNmea,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QGeoPositionInfoSourceFactorySerialNmea,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QGeoPositionInfoSourceFactorySerialNmea>"
)
set_property(TARGET Qt5::Positioning APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QGeoPositionInfoSourceFactorySerialNmea APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Positioning;Qt5::Core;Qt5::SerialPort"
)
set_property(TARGET Qt5::QGeoPositionInfoSourceFactorySerialNmea PROPERTY QT_PLUGIN_TYPE "position")
set_property(TARGET Qt5::QGeoPositionInfoSourceFactorySerialNmea PROPERTY QT_PLUGIN_EXTENDS "")
