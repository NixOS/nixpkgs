if [ -e .attrs.sh ]; then source .attrs.sh; fi
set -x

export NIX_DEBUG=1

source $stdenv/setup

export NIX_ENFORCE_PURITY=1

mkdir $out
mkdir $out/bin

cat > hello.c <<EOF
#include <stdio.h>

int main(int argc, char * * argv)
{
    printf("Hello World!\n");
    return 0;
}
EOF

#gcc -I/nix/store/foo -I /nix/store/foo -I/usr/lib -I /usr/lib hello.c -o $out/bin/hello
gcc -I`pwd` -L /nix/store/abcd/lib -isystem /usr/lib hello.c -o $out/bin/hello

$out/bin/hello

cat > hello2.cc <<EOF
#include <iostream>

int main(int argc, char * * argv)
{
    std::cout << "Hello World!\n";
    std::cout << VALUE << std::endl;
    return 0;
}
EOF

g++ hello2.cc -o $out/bin/hello2 -DVALUE="1 + 2 * 3"

$out/bin/hello2

ld -v
