if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    message(STATUS "Using Clang compiler")
    # setup your Clang toolchain here
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    message(STATUS "Using GNU compiler")

    # compiler hardening
    # https://best.openssf.org/Compiler-Hardening-Guides/Compiler-Options-Hardening-Guide-for-C-and-C++.html
    if (${CMAKE_CXX_COMPILER_VERSION} VERSION_GREATER_EQUAL "12.0")
        # Fortify sources with compile- and run-time checks for unsafe libc usage and buffer overflows.
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_FORTIFY_SOURCE=3 -O2")
        # Perform trivial auto variable initialization
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ftrivial-auto-var-init=zero")
    else ()
        # Fortify sources with compile- and run-time checks for unsafe libc usage and buffer overflows.
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_FORTIFY_SOURCE=2 -O2")
    endif ()
    
    if (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "aarch64")
        # Enable branch protection against ROP and JOP attacks on AArch64
        # https://developer.arm.com/documentation/102433/0200/Applying-these-techniques-to-real-code
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mbranch-protection=standard")
    elseif (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")
        # Enable control-flow protection against return-oriented programming (ROP) and jump-priented programming (JOP) attacks on x86_64
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fcf-protection=full")
    endif ()

    # Precondition checks for C++ standard library calls. Can impact performance.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_GLIBCXX_ASSERTIONS")
    # Enable run-time checks for variable-size stack allocation validity. Can impact performance.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fstack-clash-protection")
    # Enable run-time checks for stack-based buffer overflows. Can impact performance.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fstack-protector-strong")

    add_definitions(
        -W
        -Wunused-variable
        -Wunused-parameter
        -Wunused-function
        -Wunused
        -Wno-system-headers
        -Wno-deprecated
        -Woverloaded-virtual
        -Wwrite-strings
        -Wall
    )

    if (NOT WIN32)
        # Build as position-independent executable. Can impact performance on 32-bit architectures. (-fPIE -pie)
        # Mark relocation table entries resolved at load-time as read-only. -Wl,-z,now can impact startup performance.
        # Full RELRO (-Wl,-z,relro -Wl,-z,now) disables lazy binding.
        # This allows ld.so to resolve the entire GOT at application startup and mark also the PLT portion of the GOT as read-only.
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIE -Wl,-z,relro -Wl,-z,now")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--disable-new-dtags -pie -Wl,-z,relro -Wl,-z,now")
    
        if (COVERAGE_TRACKING)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
            set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lgcov")
            set(CMAKE_CXX_OUTPUT_EXTENSION_REPLACE 1)
    
            add_definitions(
                -fprofile-arcs
                -ftest-coverage
                -fdiagnostics-color=auto
                -lgcov
            )
        endif()
    endif()

elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
  # setup your MSVC toolchain here
endif()
