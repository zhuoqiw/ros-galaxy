if(NOT TARGET GALAXY::GALAXY)
  add_library(GALAXY::GALAXY SHARED IMPORTED)
  set_target_properties(GALAXY::GALAXY PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/inc"
    IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/lib/armv8/libgxiapi.so"
    IMPORTED_NO_SONAME TRUE
  )
endif()
