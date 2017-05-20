{ stdenv, appleDerivation, libdispatch, Libsystem }:

appleDerivation {
  # these are included in the pure libc
  buildInputs = stdenv.lib.optionals stdenv.cc.nativeLibc [ libdispatch Libsystem ];

  buildPhase = ''
    cp ${./auto_dtrace.h} ./auto_dtrace.h

    substituteInPlace ThreadLocalCollector.h --replace SubZone.h Subzone.h

    substituteInPlace auto_zone.cpp \
      --replace "#include <msgtracer_client.h>" ''$'#include <asl.h>\nstatic void msgtracer_log_with_keys(...) { };'

    substituteInPlace Definitions.h \
      --replace "#include <System/pthread_machdep.h>" "" \
      --replace 'void * const, void * const' 'void * const, void *'

    # getspecific_direct is more efficient, but this should be equivalent...
    substituteInPlace Zone.h \
      --replace "_pthread_getspecific_direct" "pthread_getspecific" \
      --replace "_pthread_has_direct_tsd()" "0" \
      --replace "__PTK_FRAMEWORK_GC_KEY0" "110" \
      --replace "__PTK_FRAMEWORK_GC_KEY1" "111" \
      --replace "__PTK_FRAMEWORK_GC_KEY2" "112" \
      --replace "__PTK_FRAMEWORK_GC_KEY3" "113" \
      --replace "__PTK_FRAMEWORK_GC_KEY4" "114" \
      --replace "__PTK_FRAMEWORK_GC_KEY5" "115" \
      --replace "__PTK_FRAMEWORK_GC_KEY6" "116" \
      --replace "__PTK_FRAMEWORK_GC_KEY7" "117" \
      --replace "__PTK_FRAMEWORK_GC_KEY8" "118" \
      --replace "__PTK_FRAMEWORK_GC_KEY9" "119"

    substituteInPlace auto_zone.cpp \
      --replace "__PTK_FRAMEWORK_GC_KEY9" "119" \
      --replace "__PTK_FRAMEWORK_GC_KEY0" "110" \

    substituteInPlace Zone.cpp \
      --replace "_pthread_getspecific_direct" "pthread_getspecific" \
      --replace "__PTK_FRAMEWORK_GC_KEY9" "119" \
      --replace "__PTK_FRAMEWORK_GC_KEY0" "110" \
      --replace "__PTK_LIBDISPATCH_KEY0"  "20" \
      --replace "struct auto_zone_cursor {" ''$'extern "C" int pthread_key_init_np(int, void (*)(void *));\nstruct auto_zone_cursor {'

    substituteInPlace auto_impl_utilities.c \
      --replace "#   include <CrashReporterClient.h>" "void CRSetCrashLogMessage(void *msg) { };"

    c++ -I. -O3 -c -Wno-c++11-extensions auto_zone.cpp
    cc  -I. -O3 -Iauto_tester -c auto_impl_utilities.c
    c++ -I. -O3 -c auto_weak.cpp
    c++ -I. -O3 -c Admin.cpp
    c++ -I. -O3 -c Bitmap.cpp
    c++ -I. -O3 -c Definitions.cpp
    c++ -I. -O3 -c Environment.cpp
    c++ -I. -O3 -c Large.cpp
    c++ -I. -O3 -c Region.cpp
    c++ -I. -O3 -c Subzone.cpp
    c++ -I. -O3 -c WriteBarrier.cpp
    c++ -I. -O3 -c Zone.cpp
    c++ -I. -O3 -c Thread.cpp
    c++ -I. -O3 -c InUseEnumerator.cpp
    c++ -I. -O3 -c auto_gdb_interface.cpp
    c++ -I. -O3 -c PointerHash.cpp
    c++ -I. -O3 -c ThreadLocalCollector.cpp
    c++ -I. -O3 -c ZoneDump.cpp
    c++ -I. -O3 -c ZoneCollectors.cpp
    c++ -I. -O3 -c SubzonePartition.cpp
    c++ -I. -O3 -c ZoneCollectionChecking.cpp
    c++ -I. -O3 -c ZoneCompaction.cpp
    c++ -I. -O3 -c BlockRef.cpp

    c++ -Wl,-no_dtrace_dof --stdlib=libc++ -dynamiclib -install_name $out/lib/libauto.dylib -o libauto.dylib *.o
  '';

  installPhase = ''
    mkdir -p $out/lib $out/include
    cp auto_zone.h auto_weak.h auto_tester/auto_tester.h auto_gdb_interface.h $out/include
    cp libauto.dylib $out/lib
  '';
}
