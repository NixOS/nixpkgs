#pragma once

#include <iostream>
#include <nix/types.hh>
#include <string>

nix::Strings parseAttrPath(const std::string & s);
bool isVarName(const std::string & s);
std::ostream & printStringValue(std::ostream & str, const char * string);
