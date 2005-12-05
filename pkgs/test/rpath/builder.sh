export NIX_DEBUG=1

source $stdenv/setup

mkdir $out
mkdir $out/bin


# 1: link statically against glibc.
res=$out/bin/hello1
gcc -static $src/hello1.c -o $res

case $(ldd $res) in
  *"not a dynamic executable"*)
        ;;
  *)
        echo "$res not statically linked!"
        exit 1
esac


# 2: link dynamically against glibc.
res=$out/bin/hello2
gcc $src/hello1.c -o $res

case $(ldd $res) in
  */store/*glibc*/lib/libc.so*/store/*glibc*/lib/ld-linux.so*)
        ;;
  *)
        echo "$res not dynamically linked / bad rpath!"
        exit 1
        ;;
esac


# 3: link C++ dynamically against glibc / libstdc++.
res=$out/bin/hello3
g++ $src/hello2.cc -o $res

case $(ldd $res) in
  */store/*gcc*/lib/*libstdc++*/store/*glibc*/lib/libm*/store/*gcc*/lib/libgcc_s*/store/*glibc*/lib/libc.so*/store/*glibc*/lib/ld-linux.so*)
        ;;
  *)
        echo "$res not dynamically linked / bad rpath!"
        exit 1
        ;;
esac


# 4: build dynamic library locally, link against it, copy it.
res=$out/bin/hello4
mkdir bla
gcc -shared $src/text.c -o bla/libtext.so 
gcc $src/hello3.c -o $res -L$(pwd)/bla -ltext
mkdir $out/lib

case $(ldd $res) in
  */tmp*)
        echo "$res depends on file in /tmp!"
        exit 1
        ;;
esac

cp bla/libtext.so $out/lib

case $(ldd $res) in
  */store/*glibc*/lib/libc.so*/store/*glibc*/lib/ld-linux.so*)
        ;;
  *)
        echo "$res not dynamically linked / bad rpath!"
        exit 1
        ;;
esac


# Run the programs we just made.
for i in $out/bin/*; do
    $i
done
