/* pkgs/top-level/lua-generated-packages.nix is an auto-generated file -- DO NOT EDIT!
Regenerate it with:
nixpkgs$ maintainers/scripts/update-luarocks-packages.sh pkgs/top-level/lua-generated-packages.nix
*/
{
self
, lua
, buildLuarocksPackage
, stdenv
, fetchurl
, luaAtLeast
, luaOlder
, isLua51
, isLua52
, ...
} @ args:
with self;
rec {
lrexlib-posix = buildLuarocksPackage rec {
  pname = "lrexlib-posix";
  version = "2.9.0-1";

  src = fetchurl {
    url    = https://luarocks.org/lrexlib-posix-2.9.0-1.src.rock;
    sha256 = "0ifpybf4m94g1nk70l0f5m45gph0rbp5wrxrl1hnw8ibv3mc1b1r";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description="Regular expression library binding (POSIX flavour).";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luaevent = buildLuarocksPackage rec {
  pname = "luaevent";
  version = "0.4.4-1";

  src = fetchurl {
    url    = https://luarocks.org/luaevent-0.4.4-1.src.rock;
    sha256 = "0yabg93m857mrnwyzxvpzx0jmlg8zdm0q1s3nmgrya1pmvzsz67g";
  };
  disabled = ( luaOlder "5.1") ;

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/harningt/luaevent";
    description="libevent binding for Lua";
    license = {
      fullName = "MIT";
    };
  };
};
coxpcall = buildLuarocksPackage rec {
  pname = "coxpcall";
  version = "1.17.0-1";

  src = fetchurl {
    url    = https://luarocks.org/manifests/hisham/coxpcall-1.17.0-1.src.rock;
    sha256 = "0n1jmda4g7x06458596bamhzhcsly6x0p31yp6q3jz4j11zv1zhi";
  };


  propagatedBuildInputs = [  ];

  buildType="builtin";

  meta = {
    homepage = "http://keplerproject.github.io/coxpcall";
    description="Coroutine safe xpcall and pcall";
    license = {
      fullName = "MIT/X11";
    };
  };
};
std__debug = buildLuarocksPackage rec {
  pname = "std._debug";
  version = "1.0-1";

  src = fetchurl {
    url    = https://luarocks.org/std._debug-1.0-1.src.rock;
    sha256 = "1b1y3xia06pk7i03l9kncy3iwxanl2hv05na4vfzhjz99l606i3m";
  };
  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.4");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://lua-stdlib.github.io/_debug";
    description="Debug Hints Library";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luv = buildLuarocksPackage rec {
  pname = "luv";
  version = "1.9.1-1";

  src = fetchurl {
    url    = https://luarocks.org/luv-1.9.1-1.src.rock;
    sha256 = "1b2gjzk7zixm98ah1xi02k1x2rhl109nqkn1w4jyjfwb3lrbhbfp";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="cmake";

  meta = {
    homepage = "https://github.com/luvit/luv";
    description="Bare libuv bindings for lua";
    license = {
      fullName = "Apache 2.0";
    };
  };
};
nvim-client = buildLuarocksPackage rec {
  pname = "nvim-client";
  version = "0.0.1-26";

  src = fetchurl {
    url    = http://luarocks.org/manifests/teto/nvim-client-0.0.1-26.src.rock;
    sha256 = "1k3rrii6w2zjmwaanldsbm8fb2d5xzzfwzwjipikxsabivhrm9hs";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua mpack luv coxpcall   ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/neovim/lua-client/archive/0.0.1-26.tar.gz";
    description="Lua client to Nvim";
    license = {
      fullName = "Apache";
    };
  };
};
lrexlib-gnu = buildLuarocksPackage rec {
  pname = "lrexlib-gnu";
  version = "2.9.0-1";

  src = fetchurl {
    url    = https://luarocks.org/lrexlib-gnu-2.9.0-1.src.rock;
    sha256 = "036rda4rji1pbnbxk1nzjy5zmigdsiacqbzrbvciwq3lrxa2j5s2";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description="Regular expression library binding (GNU flavour).";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lpeg = buildLuarocksPackage rec {
  pname = "lpeg";
  version = "1.0.1-1";

  src = fetchurl {
    url    = https://luarocks.org/manifests/gvvaughan/lpeg-1.0.1-1.src.rock;
    sha256 = "17ganb7sd4cd6l1zy00dr9717pcqngcn8wpafx7nki2m04gf76ql";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://www.inf.puc-rio.br/~roberto/lpeg.html";
    description="Parsing Expression Grammars For Lua";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luasystem = buildLuarocksPackage rec {
  pname = "luasystem";
  version = "0.2.1-0";

  src = fetchurl {
    url    = https://luarocks.org/luasystem-0.2.1-0.src.rock;
    sha256 = "091xmp8cijgj0yzfsjrn7vljwznjnjn278ay7z9pjwpwiva0diyi";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://olivinelabs.com/luasystem/";
    description="Platform independent system calls for Lua.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
luadbi = buildLuarocksPackage rec {
  pname = "luadbi";
  version = "0.6-2";

  src = fetchurl {
    url    = https://luarocks.org/luadbi-0.6-2.src.rock;
    sha256 = "1hil1h5yi44avjsvmhmvmgma2yl6yvkagxxvsvgpsdmp8jvn6gvj";
  };
  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.4");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description="Database abstraction layer";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lua-iconv = buildLuarocksPackage rec {
  pname = "lua-iconv";
  version = "7-3";

  src = fetchurl {
    url    = https://luarocks.org/lua-iconv-7-3.src.rock;
    sha256 = "03xibhcqwihyjhxnzv367q4bfmzmffxl49lmjsq77g0prw8v0q83";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://ittner.github.com/lua-iconv/";
    description="Lua binding to the iconv";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lua-cmsgpack = buildLuarocksPackage rec {
  pname = "lua-cmsgpack";
  version = "0.3-2";

  src = fetchurl {
    url    = https://luarocks.org/lua-cmsgpack-0.3-2.src.rock;
    sha256 = "062nk6y99d24qhahwp9ss4q2xhrx40djpl4vgbpmjs8wv0ds84di";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://github.com/antirez/lua-cmsgpack";
    description="MessagePack C implementation and bindings for Lua 5.1";
    license = {
      fullName = "Two-clause BSD";
    };
  };
};
luaffi = buildLuarocksPackage rec {
  pname = "luaffi";
  version = "scm-1";

  src = fetchurl {
    url    = http://luarocks.org/dev/luaffi-scm-1.src.rock;
    sha256 = "0dia66w8sgzw26bwy36gzyb2hyv7kh9n95lh5dl0158rqa6fsf26";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/facebook/luaffifb";
    description="FFI library for calling C functions from lua";
    license = {
      fullName = "BSD";
    };
  };
};
std_normalize = buildLuarocksPackage rec {
  pname = "std.normalize";
  version = "2.0.2-1";

  src = fetchurl {
    url    = https://luarocks.org/std.normalize-2.0.2-1.src.rock;
    sha256 = "0yn60zqnxflhhlv6xk6w0ifdfxk1qcg8gq1wnrrbwsxwpipsrfjh";
  };
  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.4");

  propagatedBuildInputs = [lua std__debug   ];

  buildType="builtin";

  meta = {
    homepage = "https://lua-stdlib.github.io/normalize";
    description="Normalized Lua Functions";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lua-term = buildLuarocksPackage rec {
  pname = "lua-term";
  version = "0.3-1";

  src = fetchurl {
    url    = https://luarocks.org/lua-term-0.3-1.src.rock;
    sha256 = "1bxfaskb30hpcaz8jmv5mshp56dgxlc2bm6fgf02z556cdy3kapm";
  };


  propagatedBuildInputs = [  ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/hoelzro/lua-term";
    description="Terminal functions for Lua";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lua_cliargs = buildLuarocksPackage rec {
  pname = "lua_cliargs";
  version = "3.0-1";

  src = fetchurl {
    url    = https://luarocks.org/lua_cliargs-3.0-1.src.rock;
    sha256 = "1m17pxirngpm5b1k71rqs8zlwwav1rv52z8d4w8kmj0xn4kvcrfi";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/amireh/lua_cliargs";
    description="A command-line argument parser.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
say = buildLuarocksPackage rec {
  pname = "say";
  version = "1.2-1";

  src = fetchurl {
    url    = https://luarocks.org/say-1.2-1.src.rock;
    sha256 = "0x367gyfzdv853ag2bbg5a2hsis4i9ryhb5brxp9gh136in5wjcw";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description="Lua String Hashing/Indexing Library";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
lpty = buildLuarocksPackage rec {
  pname = "lpty";
  version = "1.2.2-1";

  src = fetchurl {
    url    = https://luarocks.org/lpty-1.2.2-1.src.rock;
    sha256 = "1vxvsjgjfirl6ranz6k4q4y2dnxqh72bndbk400if22x8lqbkxzm";
  };
  disabled = ( luaOlder "5.1") ;

  propagatedBuildInputs = [lua   ];

  buildType="make";

  meta = {
    homepage = "http://www.tset.de/lpty/";
    description="A simple facility for lua to control other programs via PTYs.";
    license = {
      fullName = "MIT";
    };
  };
};
luaposix = buildLuarocksPackage rec {
  pname = "luaposix";
  version = "34.0.4-1";

  src = fetchurl {
    url    = https://luarocks.org/luaposix-34.0.4-1.src.rock;
    sha256 = "0yrm5cn2iyd0zjd4liyj27srphvy0gjrjx572swar6zqr4dwjqp2";
  };
  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.4");

  propagatedBuildInputs = [bit32 lua std_normalize   ];

  buildType="command";

  meta = {
    homepage = "http://github.com/luaposix/luaposix/";
    description="Lua bindings for POSIX";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lua-cjson = buildLuarocksPackage rec {
  pname = "lua-cjson";
  version = "2.1.0-1";

  src = fetchurl {
    url    = https://luarocks.org/lua-cjson-2.1.0-1.src.rock;
    sha256 = "0wmr0xr7qjj7gixfnja7nbkrn3jknmb4mzi9yxsa9lamqm4zhynv";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://www.kyne.com.au/~mark/software/lua-cjson.php";
    description="A fast JSON encoding/parsing module";
    license = {
      fullName = "MIT";
    };
  };
};
dkjson = buildLuarocksPackage rec {
  pname = "dkjson";
  version = "2.5-2";

  src = fetchurl {
    url    = https://luarocks.org/dkjson-2.5-2.src.rock;
    sha256 = "1qy9bzqnb9pf9d48hik4iq8h68aw3270kmax7mmpvvpw7kkyp483";
  };
  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.4");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://dkolf.de/src/dkjson-lua.fsl/";
    description="David Kolf's JSON module for Lua";
    license = {
      fullName = "MIT/X11";
    };
  };
};
busted = buildLuarocksPackage rec {
  pname = "busted";
  version = "2.0.rc12-1";

  src = fetchurl {
    url    = http://luarocks.org/manifests/teto/busted-2.0.rc12-1.src.rock;
    sha256 = "18fzdc7ww4nxwinnw9ah5hi329ghrf0h8xrwcy26lk9qcs9n079z";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua lua_cliargs luafilesystem luasystem dkjson say luassert lua-term penlight mediator_lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description="Elegant Lua unit testing.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
mpack = buildLuarocksPackage rec {
  pname = "mpack";
  version = "1.0.7-0";

  src = fetchurl {
    url    = http://luarocks.org/manifests/teto/mpack-1.0.7-0.src.rock;
    sha256 = "0nq4ixaminkc7fwfpivysyv0al3j5dffsvgdrnwnqdg3w7jgfbw7";
  };


  propagatedBuildInputs = [  ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.7/libmpack-lua-1.0.7.tar.gz";
    description="Lua binding to libmpack";
    license = {
      fullName = "MIT";
    };
  };
};
luassert = buildLuarocksPackage rec {
  pname = "luassert";
  version = "1.7.10-0";

  src = fetchurl {
    url    = http://luarocks.org/manifests/teto/luassert-1.7.10-0.src.rock;
    sha256 = "03kd0zhpl2ir0r45z12bayvwahy8pbbcwk1vfphf0zx11ik84rss";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua say   ];

  buildType="builtin";

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description="Lua Assertions Extension";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
ltermbox = buildLuarocksPackage rec {
  pname = "ltermbox";
  version = "0.2-1";

  src = fetchurl {
    url    = https://luarocks.org/ltermbox-0.2-1.src.rock;
    sha256 = "08jqlmmskbi1ml1i34dlmg6hxcs60nlm32dahpxhcrgjnfihmyn8";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://code.google.com/p/termbox";
    description="A termbox library package";
    license = {
      fullName = "New BSD License";
    };
  };
};
luafilesystem = buildLuarocksPackage rec {
  pname = "luafilesystem";
  version = "1.7.0-2";

  src = fetchurl {
    url    = https://luarocks.org/luafilesystem-1.7.0-2.src.rock;
    sha256 = "0xhmd08zklsgpnpjr9rjipah35fbs8jd4v4va36xd8bpwlvx9rk5";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "git://github.com/keplerproject/luafilesystem";
    description="File System Library for the Lua Programming Language";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luaexpat = buildLuarocksPackage rec {
  pname = "luaexpat";
  version = "1.3.0-1";

  src = fetchurl {
    url    = https://luarocks.org/luaexpat-1.3.0-1.src.rock;
    sha256 = "15jqz5q12i9zvjyagzwz2lrpzya64mih8v1hxwr0wl2gsjh86y5a";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://www.keplerproject.org/luaexpat/";
    description="XML Expat parsing";
    license = {
      fullName = "MIT/X11";
    };
  };
};
mediator_lua = buildLuarocksPackage rec {
  pname = "mediator_lua";
  version = "1.1.2-0";

  src = fetchurl {
    url    = http://luarocks.org/manifests/teto/mediator_lua-1.1.2-0.src.rock;
    sha256 = "18j49vvs94yfk4fw0xsq4v3j4difr6c99gfba0kxairmcqamd1if";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://olivinelabs.com/mediator_lua/";
    description="Event handling through channels";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
luacheck = buildLuarocksPackage rec {
  pname = "luacheck";
  version = "0.21.2-1";

  src = fetchurl {
    url    = https://luarocks.org/luacheck-0.21.2-1.src.rock;
    sha256 = "0lwr8fz40k25psir08m9il82f4slciw42j337h285qqh2szv7sf9";
  };
  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.4");

  propagatedBuildInputs = [lua luafilesystem   ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/mpeterv/luacheck";
    description="A static analyzer and a linter for Lua";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
lua-zlib = buildLuarocksPackage rec {
  pname = "lua-zlib";
  version = "1.2-0";

  src = fetchurl {
    url    = https://luarocks.org/lua-zlib-1.2-0.src.rock;
    sha256 = "0qa0vnx45nxdj6fqag6fr627zsnd2bmrr9bdbm8jv6lcnyi6nhs2";
  };
  disabled = ( luaOlder "5.1") ;

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/brimworks/lua-zlib";
    description="Simple streaming interface to zlib for Lua.";
    license = {
      fullName = "MIT";
    };
  };
};
ansicolors = buildLuarocksPackage rec {
  pname = "ansicolors";
  version = "1.0.2-3";

  src = fetchurl {
    url    = https://luarocks.org/ansicolors-1.0.2-3.src.rock;
    sha256 = "1mhmr090y5394x1j8p44ws17sdwixn5a0r4i052bkfgk3982cqfz";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/kikito/ansicolors.lua";
    description="Library for color Manipulation.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
penlight = buildLuarocksPackage rec {
  pname = "penlight";
  version = "1.3.1-1";

  src = fetchurl {
    url    = https://luarocks.org/penlight-1.3.1-1.src.rock;
    sha256 = "10w7yf1n3nrr5ima9aggs9zd7mwiynb29df4vl2qb6ca0p2zrihk";
  };


  propagatedBuildInputs = [luafilesystem   ];

  buildType="builtin";

  meta = {
    homepage = "http://stevedonovan.github.com/Penlight";
    description="Lua utility libraries loosely based on the Python standard libraries";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luuid = buildLuarocksPackage rec {
  pname = "luuid";
  version = "20120509-2";

  src = fetchurl {
    url    = https://luarocks.org/luuid-20120509-2.src.rock;
    sha256 = "08q54x0m51w89np3n117h2a153wsgv3qayabd8cz6i55qm544hkg";
  };
  disabled = ( luaOlder "5.2") || ( luaAtLeast "5.4");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#luuid";
    description="A library for UUID generation";
    license = {
      fullName = "Public domain";
    };
  };
};
luazip = buildLuarocksPackage rec {
  pname = "luazip";
  version = "1.2.7-1";

  src = fetchurl {
    url    = https://luarocks.org/luazip-1.2.7-1.src.rock;
    sha256 = "1yprlr1ap6bhshhy88qfphmmyg9zp1py2hj2158iw6vsva0fk03l";
  };
  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.4");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/mpeterv/luazip";
    description="Library for reading files inside zip files";
    license = {
      fullName = "MIT";
    };
  };
};
luasec = buildLuarocksPackage rec {
  pname = "luasec";
  version = "0.7alpha-2";

  src = fetchurl {
    url    = https://luarocks.org/luasec-0.7alpha-2.src.rock;
    sha256 = "1292mlmxcp6i205081n512b4c6zsbjxrjfjjlfmn0spqfdc64m51";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua luasocket   ];

  buildType="builtin";

  meta = {
    homepage = "https://github.com/brunoos/luasec/wiki";
    description="A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket.";
    license = {
      fullName = "MIT";
    };
  };
};
luasocket = buildLuarocksPackage rec {
  pname = "luasocket";
  version = "3.0rc1-2";

  src = fetchurl {
    url    = https://luarocks.org/luasocket-3.0rc1-2.src.rock;
    sha256 = "1isin9m40ixpqng6ds47skwa4zxrc6w8blza8gmmq566w6hz50iq";
  };
  disabled = ( luaOlder "5.1");

  propagatedBuildInputs = [lua   ];

  buildType="builtin";

  meta = {
    homepage = "http://luaforge.net/projects/luasocket/";
    description="Network support for the Lua language";
    license = {
      fullName = "MIT";
    };
  };
};
}
/* GENERATED */
