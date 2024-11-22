// These are useful methods inside the nix library that ought to be exported.
// Since they are not, copy/paste them here.
// TODO: Delete these and use the ones in the library as they become available.

#include "libnix-copy-paste.hh"
#include <nix/print.hh>                           // for Strings

// From nix/src/nix/repl.cc
bool isVarName(const std::string_view & s)
{
    if (s.size() == 0) return false;
    if (nix::isReservedKeyword(s)) return false;
    char c = s[0];
    if ((c >= '0' && c <= '9') || c == '-' || c == '\'') return false;
    for (auto & i : s)
        if (!((i >= 'a' && i <= 'z') ||
              (i >= 'A' && i <= 'Z') ||
              (i >= '0' && i <= '9') ||
              i == '_' || i == '-' || i == '\''))
            return false;
    return true;
}
