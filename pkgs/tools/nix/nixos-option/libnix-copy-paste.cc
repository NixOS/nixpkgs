// These are useful methods inside the nix library that ought to be exported.
// Since they are not, copy/paste them here.
// TODO: Delete these and use the ones in the library as they become available.

#include <nix/config.h> // for nix/globals.hh's reference to SYSTEM

#include "libnix-copy-paste.hh"
#include <boost/format/alt_sstream.hpp>           // for basic_altstringbuf...
#include <boost/format/alt_sstream_impl.hpp>      // for basic_altstringbuf...
#include <boost/optional/optional.hpp>            // for get_pointer
#include <iostream>                               // for operator<<, basic_...
#include <nix/types.hh>                           // for Strings
#include <nix/error.hh>                           // for Error
#include <string>                                 // for string, basic_string

using nix::Error;
using nix::Strings;
using std::string;

// From nix/src/libexpr/attr-path.cc
Strings parseAttrPath(const string & s)
{
    Strings res;
    string cur;
    string::const_iterator i = s.begin();
    while (i != s.end()) {
        if (*i == '.') {
            res.push_back(cur);
            cur.clear();
        } else if (*i == '"') {
            ++i;
            while (1) {
                if (i == s.end())
                    throw Error("missing closing quote in selection path '%1%'", s);
                if (*i == '"')
                    break;
                cur.push_back(*i++);
            }
        } else
            cur.push_back(*i);
        ++i;
    }
    if (!cur.empty())
        res.push_back(cur);
    return res;
}

// From nix/src/nix/repl.cc
bool isVarName(const string & s)
{
    if (s.size() == 0)
        return false;
    char c = s[0];
    if ((c >= '0' && c <= '9') || c == '-' || c == '\'')
        return false;
    for (auto & i : s)
        if (!((i >= 'a' && i <= 'z') || (i >= 'A' && i <= 'Z') || (i >= '0' && i <= '9') || i == '_' || i == '-' ||
              i == '\''))
            return false;
    return true;
}

// From nix/src/nix/repl.cc
std::ostream & printStringValue(std::ostream & str, const char * string)
{
    str << "\"";
    for (const char * i = string; *i; i++)
        if (*i == '\"' || *i == '\\')
            str << "\\" << *i;
        else if (*i == '\n')
            str << "\\n";
        else if (*i == '\r')
            str << "\\r";
        else if (*i == '\t')
            str << "\\t";
        else
            str << *i;
    str << "\"";
    return str;
}
