/* hackish collection of ghc packages
   this will be replaced in the future

   A library is defined by this attribute set:
   <attr name> = {
     name =
     src =
     p_deps = [ x.<attr name> x.<attr name> ] # x = recursive list of packages defined here and the core packages shipping with ghc
     srcDir = <subDir of source> # optional
     pass = {
      # stuff passed to the builder as is (used for patches most of the time
     };
    }
*/


# TODO use nix names (regexCompat instead of regex_compat)
args : ghc: with args;

rec {
      #   name (using lowercase letters everywhere because using installing packages having different capitalization is discouraged) - this way there is not that much to remember?

      cabal_darcs_name = "cabal-darcs";

      # introducing p here to speed things up.
      # It merges derivations (defined below) and additional inputs. I hope that using as few nix functions as possible results in greates speed?
      # unfortunately with x; won't work because it forces nix to evaluate all attributes of x which would lead to infinite recursion
      pkgs = let x = ghc.core_libs // derivations;
                 wxVersion = "0.10.3";
                 wxSrc = fetchurl { url = "mirror://sourceforge/wxhaskell/wxhaskell-src-${wxVersion}.tar.gz";
                                   sha256 = "2a9b70b92c96ef1aa3eaa3426e224c0994c24bfdaccbf2b673edef65ba3cffce"; };
                 inherit (bleedingEdgeRepos) sourceByName;
             in {
          # ghc extra packages
          mtl     = { name="mtl-1.1.0.0";     srcDir="libraries/mtl";    p_deps=[ x.base ]; src = ghc.extra_src; };
          parsec  = { name="parsec-2.1.0.0";  srcDir="libraries/parsec"; p_deps=[ x.base ]; src = ghc.extra_src; };
          network = { name="network-2.1.0.0"; srcDir="libraries/network"; p_deps=[ x.base x.parsec3 x.haskell98 ];       src = ghc.extra_src; };
          regex_base = { name="regex-base-0.72.0.1"; srcDir="libraries/regex-base"; p_deps=[ x.base x.array x.bytestring x.haskell98 ]; src = ghc.extra_src; };
          regex_posix = { name="regex-posix-0.72.0.2"; srcDir="libraries/regex-posix"; p_deps=[ x.regex_base x.haskell98 ]; src = ghc.extra_src; };
          regex_compat = { name="regex-compat-0.71.0.1"; srcDir="libraries/regex-compat"; p_deps=[ x.base x.regex_posix x.regex_base x.haskell98 ]; src = ghc.extra_src; };
          stm = { name="stm-2.1.1.0"; srcDir="libraries/stm"; p_deps=[ x.base x.array ]; src = ghc.extra_src; };
          hunit = { name="HUnit-1.2.0.0"; srcDir="libraries/HUnit"; p_deps=[ x.base ]; src = ghc.extra_src; };
          quickcheck = { name="QuickCheck-1.1.0.0"; srcDir="libraries/QuickCheck"; p_deps=[x.base x.random]; src = ghc.extra_src; };
          tagsoup = { name = "tagsoup-0.4"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/tagsoup/0.4/tagsoup-0.4.tar.gz; sha256 = "0rdy303qaw63la1fhw1z8h6k8cs33f71955pwlzxyx0n45g58hc7";};  p_deps = [ x.base x.mtl x.network ]; };
          hxt = { name = "hxt-7.5"; src =fetchurl { url = http://hackage.haskell.org/packages/archive/hxt/7.5/hxt-7.5.tar.gz; sha256 ="00q6m90a4qm4d5cg1x9r6b7f0rszcf2y7ifzs9mvy9kmzfl5ga7n"; };  p_deps = [x.base x.haskell98 x.http_darcs x.hunit x.network x.parsec x.tagsoup ]; };
          storableVector = { name = "storablevector-0.1.2.2"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/storablevector/0.1.2.2/storablevector-0.1.2.2.tar.gz; sha256="1gf2a40mv8xxppdmg9l3svshww4sg0wwdqlwjl95nhacm0f6yrhb"; }; p_deps = [ x.base x.bytestring x.mtl x.quickcheck x.random ]; };
          storableVectorDarcs = { name = "storablevector-darcs"; src = sourceByName "storableVector"; p_deps = [ x.base x.bytestring x.mtl x.quickcheck x.random ]; };
          typeInt = { name="type-int-0.4";  src = fetchurl { url = "/nix/store/cvnf71gxvk1lxnibigc2ang10hi4i5qi-type-int-0.4.tar.gz"; sha256="0h64cx2zpijaaxnzhal2m311q33drvynjbmxavh7z5b8fmaqmnws"; }; p_deps = [ x.base x.template_haskell ]; };
          typeLevel = {name="type-level-0.2.1"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/type-level/0.2.1/type-level-0.2.1.tar.gz; sha256 = "077g6i9v1wvsk1narnxp9m0svlkz9lpf0adalhlw2m7268rpr148"; }; p_deps = [ x.base x.template_haskell ]; };
          haskellnet = { name = "HaskellNet-0.2"; src = sourceByName "haskellnet"; p_deps = [ x.base x.haskell98 x.network x.crypto x.mtl x.parsec x.time x.haxml x.bytestring x.pretty x.array x.dataenc x.containers x.old_locale x.old_time ];
             pass = {
               patchPhase = "
                 patch -p1 < \$patch
                 sed -i 's/mtl/mtl, bytestring, pretty, array, dataenc, containers, old-locale, old-time/' *.cabal
                 ";
               patch= ./haskellnetPatch ;
             };
          };
          dataenc = { name = "dataenc-0.10.2"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/dataenc/0.10.2/dataenc-0.10.2.tar.gz; sha256="1kl087994ajbwy65f24qjnz6wchlhmk5vkdw1506zzfbi5fr6x7r"; }; p_deps = [ x.base ]; };
          # other pacakges  (hackage etc)
          polyparse = { name = "polyparse-2.3"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/polyparse/1.1/polyparse-1.1.tar.gz; sha256 = "0mrrk3hhfrn68xn5y4jfg4ba0pa08bj05l007862vrxyyb4bksl7"; }; p_deps = [ x.base x.haskell98 ]; };
          # plugins doesn't compile with recent cabal
          # plugins = { name="plugins-1.2"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/plugins/1.2/plugins-1.2.tar.gz; sha256 = "1v2b3p3d2d3ab8zlzad4i6yy3zmarvkd09r71yc237xx66s7i9s5"; }; p_deps = [ x.array x.base x.cabal_darcs x.containers x.directory x.ghc x.haskellSrc x.process x.random ]; };
          plugins_darcs = { name="plugins-darcs"; src = sourceByName "plugins"; p_deps = [ x.array x.base x.cabal_darcs x.containers x.directory x.ghc x.haskellSrc x.process x.random ];
              pass = { patches = ./plugins-darcs.patch; };
          };
          hinotify = { name="hinitofy-0.2"; src = fetchurl{ url = http://hackage.haskell.org/packages/archive/hinotify/0.2/hinotify-0.2.tar.gz; sha256 = "1x9mnlqy8lsq3qy9d559kxwqlj32smr9an76nf5i4hj67vicw1al"; };  p_deps = [ x.base x.containers x.directory x.unix ]; };
          harp = { name="harp-0.2.1"; src = fetchurl{ url = http://hackage.haskell.org/packages/archive/harp/0.2.1/harp-0.2.1.tar.gz; sha256 = "865e8c229e1ff89297b4348be95d93c10e373b63b7910da1e6b3330b48b96b87"; };  p_deps = [x.base]; };
          hsx = { name="hsx-0.4.4"; src = fetchurl{ url = http://hackage.haskell.org/packages/archive/hsx/0.4.4/hsx-0.4.4.tar.gz; sha256 = "1wr70h1r8vmzs1xsiiq89h0k3gips8krp5p4s4f6vjglg3w27q7h"; };  p_deps = [x.base x.haskellSrcExt x.mtl x.haskellSrcExtDarcs]; };
          # TODO remove
          # haskell_src_exts_metaquote = { name = "haskell_src_exts_metaquote-darcs"; src = sourceByName "haskell_src_exts_metaquote"; p_deps = [ x.base x.mtl x.containers x.array x.pretty x.binary x.packaged_string ]; };

          # hint = { name="hint-0.1"; src = fetchurl { url = "http://hackage.haskell.org/packages/archive/hint/0.1/hint-0.1.tar.gz"; sha256 = "1adydl2la4lxxl6zz24lm4vbdrsi4bkpppzxhpkkmzsjhhkpf2f9"; }; p_deps = [ x.base x.ghc x.haskellSrc x.mtl ]; };
          pcreLight = { name="pcre-light-0.3.1"; src= fetchurl { url = http://hackage.haskell.org/packages/archive/pcre-light/0.3.1/pcre-light-0.3.1.tar.gz; sha256 = "1h0qhfvqjcx59zkqhvsy7vw23l4444czg2z7b2lndy6cmkqc719m"; }; p_deps = [x.base x.bytestring pcre x.haskell98 ];
            pass = { patchPhase = "
                  echo \"    extra-lib-dirs: ${pcre}/lib\" >> pcre-light.cabal
                  ";
          }; };
          hsHaruPDF = { name = "HsHaruPDF-0.0.0"; src = fetchurl{url= "http://hackage.haskell.org/packages/archive/HsHaruPDF/0.0.0/HsHaruPDF-0.0.0.tar.gz"; sha256="1yifhxk1m3z2i7gaxgwlmk6cv2spbpx8fny4sn59ybca8wd9z7ps";}; p_deps = [ x.base x.haskell98 ];
                        pass = { buildInputs = [ mysql zlib libpng ];
                          patchPhase = "
                            sed 's/include-dirs:.*/include-dirs: haru/'  -i HsHaruPDF.cabal
                            sed 's=extra-lib-dirs:.*=extra-lib-dirs: ${libpng}/lib ${zlib}/lib=' -i HsHaruPDF.cabal
                            ";
                        };
          };
          # hint = { name="hint-0.1"; src = fetchurl { url = "http://hackage.haskell.org/packages/archive/hint/0.1/hint-0.1.tar.gz"; sha256 = "1adydl2la4lxxl6zz24lm4vbdrsi4bkpppzxhpkkmzsjhhkpf2f9"; }; p_deps = [ x.base x.ghc x.haskellSrc x.mtl ]; };
          bloomfilter = { name = "bloomfilter-1.2.1"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/bloomfilter/1.2.1/bloomfilter-1.2.1.tar.gz; sha256 = "1d2m0w8lgpdpykdgp08bmy5jb1c89by4xnkfy2bnh8f02nb1zlsm"; }; p_deps = [ x.base x.bytestring x.containers ]; };
          timeout = { name="timeout-0.1.2"; src = fetchurl{ url = http://hackage.haskell.org/packages/archive/control-timeout/0.1.2/control-timeout-0.1.2.tar.gz; sha256 = "1g1x6c4dafckwcw48v83f3nm2sxv8kynwv8ib236ay913ycgayvg";}; p_deps = [ x.base x.time x.stm ]; };
          parsec3  = { name="parsec-3.0.0";  p_deps=[ x.base x.mtl x.bytestring ];  src = fetchurl { url = "http://hackage.haskell.org/packages/archive/parsec/3.0.0/parsec-3.0.0.tar.gz"; sha256 = "0fqryy09y8h7z0hlayg5gpavghgwa0g3bldynwl17ks8l87ykj7a"; }; };

          binary = rec { name = "binary-0.4.1"; p_deps = [ x.base x.bytestring x.containers x.array ];
                           src = fetchurl { url = "http://hackage.haskell.org/packages/archive/binary/0.4.1/binary-0.4.1.tar.gz";
                                        sha256 = "0jg5i1k5fz0xp1piaaf5bzhagqvfl3i73hlpdmgs4gc40r1q4x5v"; };
                 };
          hlist = { name="HList-0.1"; src = fetchurl { url="http://hackage.haskell.org/packages/archive/HList/0.1/HList-0.1.tar.gz"; sha256 = "1gv80qrnf71fzgb2ywaybkfvida0pwkd4a53vhmc0yg214yin4kh"; }; p_deps = [ ]; };
          # using different name to not clash with postgresql
          postgresql_bindings = rec { name = "PostgreSQL-0.2"; p_deps = [x.base x.mtl postgresql x.haskell98];
                          src = fetchurl { url = "http://hackage.haskell.org/packages/archive/PostgreSQL/0.2/PostgreSQL-0.2.tar.gz";
                                       sha256 = "0p5q3yc8ymgzzlc600h4mb9w86ncrgjdbpqfi49b2jqvkcx5bwrr"; };
                          pass = {
                             inherit postgresql;
                             patchPhase = "echo 'extensions: MultiParamTypeClasses ForeignFunctionInterface EmptyDataDecls GeneralizedNewtypeDeriving FlexibleInstances UndecidableInstances' >> PostgreSQL.cabal
                                           echo \"extra-lib-dirs: \$postgresql/lib\" >> PostgreSQL.cabal
                                           echo \"extra-libraries: pq\" >> PostgreSQL.cabal
                                          ";

                          };
                };
          unixCompat ={ name = "unix-compat-0.1.2.1"; src = fetchurl { url=http://hackage.haskell.org/packages/archive/unix-compat/0.1.2.1/unix-compat-0.1.2.1.tar.gz; sha256 = "119fiazjr83xm4nk394v7lmsvhkic5k78pzcvv70j7zp83hjccsm"; }; p_deps = [ x.base x.directory x.old_time x.haskell98 ]; };
          tar = rec { name = "tar-0.1.1.1"; p_deps = [ x.base x.bytestring x.haskell98 x.binary x.unixCompat ];
                           src = fetchurl { url = "http://hackage.haskell.org/packages/archive/tar/0.1.1.1/tar-0.1.1.1.tar.gz";
                                        sha256 = "08ns56xxw6519q0f7fqdznhcwx5dj2rc531mivxdyja6lmmjcfcb"; };
          };
          zlib = rec { name = "zlib-0.4.0.4"; p_deps = [ x.base x.bytestring x.haskell98 ];
                           src = fetchurl { url = "http://hackage.haskell.org/packages/archive/zlib/0.4.0.4/zlib-0.4.0.4.tar.gz";
                                        sha256 = "14hzqpzqs3rcwx6qpgybrcz33yrzb5y4p0bdsilhdgl15594ibad"; };
                    pass = {
                      patchPhase = ''
                        echo      "  extra-lib-dirs: ${zlib}/lib" >> zlib.cabal
                        echo      "  include-dirs: ${zlib}/include" >> zlib.cabal'';
               }; };
          bzlib = rec { name = "bzlib-0.4.0.3"; p_deps = [ x.base x.bytestring x.haskell98 ];
                           src = fetchurl { url = "http://hackage.haskell.org/packages/archive/bzlib/0.4.0.3/bzlib-0.4.0.3.tar.gz";
                                        sha256 = "0mdhqds2d4lx75yy39bvbvmvkb81xl1mhgbjwi4299j7isrrgmb4"; };
                    pass = {
                      patchPhase = ''
                        echo   "  extra-lib-dirs: ${bzip2}/lib
                          include-dirs: ${bzip2}/include" >> bzlib.cabal '';
               }; };
          wash = rec { name = "WashNGo-2.12"; p_deps = [x.base x.mtl x.haskell98 x.regex_compat x.parsec x.containers ];
                         src = fetchurl { url = "http://www.informatik.uni-freiburg.de/~thiemann/WASH/WashNGo-2.12.tgz";
                                      sha256 = "1dyc2062jpl3xdlm0n7xkz620h060g2i5ghnb32cn95brcj9fgrz"; };
                      useLocalPkgDB = true;
                  pass = {
                    patches = ./WASHNGo_Patch_ghc682;
                  };
               };

          #hsql = rec { name = "hsql-1.7"; p_deps = [x.base x.mtl x.haskell98  x.old_time ];
                        #src = fetchurl { url = "http://hackage.haskell.org/packages/archive/hsql/1.7/hsql-1.7.tar.gz";
                                     #sha256 = "0j2lkvg5c0x5gf2sy7zmmgrda0c3l73i9d6hyka2f15d5n1rfjc9"; };
                      #pass = { patchPhase = "
                                    #sed -e 's=build-depends:.*=build-depends: base, old-locale, old-time=' -i hsql.cabal
                                    #echo \"extensions:
                                    #ForeignFunctionInterface, TypeSynonymInstances, CPP, ExistentialQuantification, GeneralizedNewtypeDeriving, PatternSignatures, ScopedTypeVariables, Rank2Types, DeriveDataTypeable \" >> hsql.cabal
                                    #"; };
              #};
          # supports new time library
          hsqlDarcs = rec { name = "hsql-darcs"; p_deps = [x.base x.mtl x.haskell98  x.old_time x.old_locale x.time ];
                        src = sourceByName "hsql";
                      pass = {  srcDir = "HSQL"; };
              };
          hsqlMysqlDarcs = { name = "hsql-mysql-darcs"; srcDir = "MySQL"; src = sourceByName "hsql"; p_deps = [ x.base x.hsqlDarcs x.old_time ];
                        pass = { buildInputs = [ mysql zlib ];
                                 patchPhase = "echo      \"  extra-lib-dirs: ${zlib}/lib\" >> MySQL/hsql-mysql.cabal
                                           sed -e \"s=configVerbose=configVerbosity=\" -e \"s=sqlite_path=\$sqlite=\" -i MySQL/Setup.lhs
                                             ";
                               };
                      };
          #hsql_postgresql = rec { name = "hsql-postgresql-1.7"; p_deps = [ x.base x.mtl x.haskell98  x.old_time x.hsql postgresql ];
          #              src = fetchurl { url = "";
          #                           sha256 = "180c8acp4p9hsl5h8ryhhli9mlqcmcfjqaxzr7sa074gpzq29vfc"; };
          #            pass = { patchPhase = "
          #                          sed -e 's=build-depends:.*=build-depends: base, old-locale, old-time=' -i hsql.cabal
          #                          echo \"extensions:
          #                          ForeignFunctionInterface, TypeSynonymInstances, CPP, ExistentialQuantification, GeneralizedNewtypeDeriving, PatternSignatures, ScopedTypeVariables, Rank2Types, DeriveDataTypeable \" >> hsql.cabal
          #                          "; };
          #    };
          # I'm getting a glibc error when compiling - where does it come from ?
          #takusen = rec { name = "takusen-0.8"; p_deps = [ x.base x.mtl x.haskell98 x.time postgresql sqlite ];
          #                src =  sourceByName "takusen";
          #                pass = {
          #                   inherit postgresql sqlite;
          #                   patch = ./takusen_setup_patch;
          #                  [> no ODBC, Oracle support in nix
          #                   patchPhase = "patch -p1 Setup.hs < \$patch
          #                                 sed -e '/ODBC/d' -i Takusen.cabal
          #                                 sed -e '/Oracle/d' -i Takusen.cabal
          #                                 sed -e \"s=pg_path=\$postgresql=\" -e \"s=sqlite_path=\$sqlite=\" -i Setup.hs
          #                                 sed -e \"s=configVerbose=configVerbosity=\" -e \"s=sqlite_path=\$sqlite=\" -i Setup.hs
          #                                 sed -e \"s=regVerbose=regVerbosity=\" -e \"s=sqlite_path=\$sqlite=\" -i Setup.hs
          #                                 ";
          #                };
          #      };
          hdbc = rec { name = "hdbc-1.1.4.0"; p_deps = [ x.base x.mtl x.haskell98 x.time x.bytestring postgresql sqlite ];
                          src = fetchurl {
                            url = http://software.complete.org/hdbc/static/download_area/1.1.4.0/hdbc_1.1.4.0.tar.gz;

                            sha256 = "677e789094e3790be2462331b6c0f97b4ac1d65c8eb98cf7d8b83d5f3f9fbd39";
                          };
                          pass = {
                             inherit postgresql sqlite;
                             #patch = ./takusen_setup_patch;
                            # no ODBC, Oracle support in nix
                             #patchPhase = "patch -p1 Setup.hs < \$patch
                             #              sed -e '/ODBC/d' -i Takusen.cabal
                             #              sed -e '/Oracle/d' -i Takusen.cabal
                             #              sed -e \"s=pg_path=\$postgresql=\" -e \"s=sqlite_path=\$sqlite=\" -i Setup.hs
                             #              ";
                          };
                };
          hdbc_postgresql = { name = "hdbc-postgresql"; p_deps = [ x.hdbc x.parsec3 postgresql ];
                              src = fetchurl {
                                url = http://hackage.haskell.org/packages/archive/HDBC-postgresql/1.1.4.0/HDBC-postgresql-1.1.4.0.tar.gz;
                                sha256 = "1b9lxj55jvvq76ll8dr4kfb6aj7r0baj4gh8wkhgwc1kd41sx7h3"; };
                              pass = {
                                  patches = [ ./hdbc_postgresql_patch ];
                                  patchPhase = "unset patchPhase; patchPhase;
                                                sed -e '/Cabal-Ver/d' -i HDBC-postgresql.cabal";
                              };
          };

          gtk2hs = rec { name = "gtk2hs-0.9.12.1"; p_deps = [ x.haskell98 x.mtl x.bytestring pkgconfig ] ++ (with gtkLibs; [ glib pango gtk gnome.glib gnome.gtksourceview]);
                          src = fetchurl {
                            url = "http://downloads.sourceforge.net/gtk2hs/${name}.tar.gz";
                            sha256 = "110z6v9gzhg6nzlz5gs8aafmipbva6rc50b8z1jgq0k2g25hfy22"; };
                          pass = {
                            buildPhase = "
                              createEmptyPackageDatabaseAndSetupHook
                              export GHC_PACKAGE_PATH
                              ./configure --prefix=\$out --with-user-pkgconf=local-pkg-db --with-pkgconf=\$PACKAGE_DB
                              make
                              ensureDir \$out
                              make install
                              ";
                          };
                        };
          hspread = { name = "hspread-0.3"; p_deps = [ x.base x.bytestring x.network x.binary ];
                          src = fetchurl {
                            url = http://hackage.haskell.org/packages/archive/hspread/0.3/hspread-0.3.tar.gz;
                            sha256 = "0lwq7v7p6akykcsz6inkg99h3z7ab1gs5nkjjlgsbyqbwvimmf5n"; };
                          pass = {
                          };
          };

          wxcore = rec {

                        name = "wxhaskel-${wxVersion}"; p_deps = [ x.haskell98 x.mtl x.bytestring x.parsec3 pkgconfig wxGTK  ] ++ (with gtkLibs; [ glib pango gtk gnome.glib]);
                        src = wxSrc;
                        pass = {
                          profiling = if getConfig [ "ghc68" "profiling" ] false then "--hcprof" else "";
                          buildInputs = [ unzip ];
                          buildPhase = "
                            createEmptyPackageDatabaseAndSetupHook
                            export GHC_PACKAGE_PATH
                            sed -e 's/which/type -p/g' configure
                            ./configure --prefix=\$out --package-conf=\$PACKAGE_DB \$profiling
                            make
                            ensureDir \$out
                            make install
                            ";
                        };
                      };

          wx = { name="wx-${wxVersion}"; src =wxSrc; srcDir="wx"; p_deps = [ x.haskell98 x.mtl x.bytestring x.parsec3 x.wxcore pkgconfig wxGTK  ] ++ (with gtkLibs; [ glib pango gtk gnome.glib]);
                #  TODO rempove pwd
                pass = { patchPhase = "pwd; cp {,wx/}license.txt"; };
            };

          typecompose = { name="TypeCompose-0.4"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/TypeCompose/0.5/TypeCompose-0.5.tar.gz; sha256 = "0mzjvwjixkp0jxfzxjw1pq8k1sm61sb5y96fk07xm91nn4sgpaqj"; }; p_deps = [ x.base ]; };
          reactive = { name="reactive-0.5"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/reactive/0.5/reactive-0.5.tar.gz; sha256 = "1giv5p2nks4rw683bkmnjmdanpx8mgqi6dzj099cjbk93jag9581"; }; p_deps = [ x.base x.typecompose ]; };
          phooey = { name="phooey-2.0"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/phooey/2.0/phooey-2.0.tar.gz; sha256 = "1bb6cn2vk7b57gaxh863ymidb4l7ldiwcnpif790rd4bq44fwfvf"; }; p_deps = [ x.base x.typecompose x.reactive x.wx x.wxcore ]; };

          # depreceated (This is the deprecated Data.FiniteMap library, often useful to get old code to build when you are too lazy to update it.)
          finitemap = { name="finitemap-0.1"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/FiniteMap/0.1/FiniteMap-0.1.tar.gz; sha256 = "1kf638h5gsc8fklhaw2jiad1r0ssgj8zkfmzywp85lrx5z529gky"; }; p_deps = [ x.base x.haskell98 ]; };

          parallel = { name = "parallel-1.0.0.0"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/parallel/1.0.0.0/parallel-1.0.0.0.tar.gz; sha256 = "0f6g724zpdqhjcfv064yknrdx4rjaaj71bfx57c8ywizifcwxp4h"; }; p_deps = [x.base]; };

          httpSimple = { name = "HTTP-Simple-0.1"; src = fetchurl { url =  http://hackage.haskell.org/packages/archive/HTTP-Simple/0.1/HTTP-Simple-0.1.tar.gz; sha256 = "0mbszgx8x02wry2h8jhdc51ryi7dwbi396y5h4k6p0bva8yp5bd0"; }; p_deps = [x.base x.network x.http_darcs]; };

          deeparrow = { name = "DeepArrow-0.2"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/DeepArrow/0.2/DeepArrow-0.2.tar.gz; sha256 = "1rm55nryg2z4r5919da2cc3nq08cg0g9gf59qfzl50lfccq8x2wd"; }; p_deps = [ x.base x.mtl x.typecompose x.haskellSrc ]; };
          tv = { name = "TV-0.4"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/TV/0.4/TV-0.4.tar.gz; sha256 = "0hracvx6pydmqfkx9n906k0463b0qaxskis91kir63ivf91zwndp"; }; p_deps = [ x.base  x.typecompose x.deeparrow]; };
          guitv = { name = "GuiTV-0.4"; src = fetchurl { url = http://darcs.haskell.org/packages/GuiTV/dist/GuiTV-0.4.tar.gz; sha256 = "15mndbxm83q0d8ci3vj51zwrmzl0f5i5yqv0caw05vlzfsr4ib5i";}; p_deps = [ x.base x.deeparrow x.typecompose x.phooey x.tv ]; };

          haskellSrc = { name = "haskell-src-1.0.1.1"; src = fetchurl { url = "http://hackage.haskell.org/packages/archive/haskell-src/1.0.1.1/haskell-src-1.0.1.1.tar.gz"; sha256 = "06kilrf7y5h6dxj57kwymr20zvdsq6zhchwn4wky12mrmzjxyj01"; }; p_deps = [ x.haskell98 x.base x.pretty x.array ];
                      pass = { buildInputs = (with executables; [ happy alex ] ); };
                      };
          haskellSrcExt = { name = "haskell-src-exts-0.3.3.tar.gz"; src = fetchurl  { url = "http://hackage.haskell.org/packages/archive/haskell-src-exts/0.3.3/haskell-src-exts-0.3.3.tar.gz"; sha256 = "0g9ibjj1k5k3mqfx5mp8pqr0zx53pp9dkf52r8cdv18bl8xhzbpx"; }; p_deps = [ x.base x.base x.array x.pretty ];
                      pass = { buildInputs = (with executables; [ happy alex ] ); };
                    };
          haskellSrcExtDarcs = { name = "haskell-src-exts-darcs"; src = sourceByName "haskell_src_exts"; p_deps = [ x.base x.base x.array x.pretty ];
                      pass = { buildInputs = (with executables; [ happy alex ] ); };
                    };

          # haskelldb
          haskelldb = { name = "haskelldb-0.10"; src = fetchurl  { url = "http://hackage.haskell.org/packages/archive/haskelldb/0.10/haskelldb-0.10.tar.gz"; sha256 = "1i4kgsgajr9cijg0a2c04rn1zqwiasfvdbvs8c5qm49vkbdzm7l5"; }; p_deps = [ x.base x.haskell98 x.mtl x.pretty x.old_time x.directory x.old_locale];
                    pass = { patchPhase = "sed -i 's/mtl/mtl, pretty, old-time, directory, old-locale/' haskelldb.cabal
                                            echo 'ghc-options: -O2 -fglasgow-exts -fallow-undecidable-instances' >> haskelldb.cabal"; };
          };
          #hsql drivers
          haskelldbHsql = { name= "haskelldb-hsql--0.10"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/haskelldb-hsql/0.10/haskelldb-hsql-0.10.tar.gz; sha256 = "0s3bjm080hzw23zjxr4412m81v408ll9y6gqb2yyw30n886ixzgh"; }; p_deps = [ x.base x.haskell98 x.mtl x.hsqlDarcs x.haskelldb x.old_time x.old_locale ];
                        pass = { patchPhase = "sed -i 's/mtl/mtl, pretty, old-time, directory, old-locale/' haskelldb-hsql.cabal
                                                echo 'ghc-options: -O2 -fglasgow-exts -fallow-undecidable-instances' >> haskelldb-hsql.cabal"; };
                        };
          haskelldbHsqlMysql = { name= "haskelldb-hsql-mysql-0.10"; src = fetchurl { url = http://hackage.haskell.org/packages/archive/haskelldb-hsql-mysql/0.10/haskelldb-hsql-mysql-0.10.tar.gz; sha256 = "0nfgq0xn45rhwxr8jvawviqfhgvhqr56l7ki1d72605y34dfx7rw"; }; p_deps = [ x.base x.haskell98 x.mtl x.hsqlDarcs x.haskelldbHsql x.hsqlMysqlDarcs x.haskelldb ]; };

          getOptions = rec { name = "GetOptions"; p_deps = [ x.haskell98 x.base x.mtl ];
                           src = sourceByName "getOptions";
                     };

          # 1.13 is stable. There are more recent non stable versions
          haxml = rec { name = "HaXml-1.13.3"; p_deps = [ x.base x.rts x.directory x.process x.pretty x.containers x.filepath x.haskell98 ];
                           src = fetchurl { url = "http://www.haskell.org/HaXml/${name}.tar.gz";
                                            sha256 = "08d9wy0rg9m66dd10x0zvkl74l25vxdakz7xp3j88s2gd31jp1v0"; };
                     };
          haxml_darcs = { name = "HaXml-darcs"; p_deps = [ x.base x.rts x.directory x.process x.pretty x.containers x.filepath x.haskell98 x.polyparse x.bytestring ];
                           src = sourceByName "haxml";
                     };
          xhtml = rec { name = "xhtml-3000.0.2.2"; p_deps = [ x.base ];
                           src = fetchurl { url = "http://hackage.haskell.org/packages/archive/xhtml/3000.0.2.2/xhtml-3000.0.2.2.tar.gz";
                                            sha256 = "112mbq26ksh7r22y09h0xvm347kba3p4ns12vj5498fqqj333878"; };
                     };
          html = rec { name = "html-1.0.1.1"; p_deps = [ x.base ];
                           src = fetchurl { url = "http://hackage.haskell.org/packages/archive/html/1.0.1.1/html-1.0.1.1.tar.gz";
                                            sha256 = "10fayfm18p83zlkr9ikxlqgnzxg1ckdqaqvz6wp1xj95fy3p6yl1"; };
                     };
          crypto = rec { name = "crypto-4.1.0"; p_deps = [ x.base x.array x.pretty x.quickcheck x.random x.hunit ];
                           src = fetchurl { url = "http://hackage.haskell.org/packages/archive/Crypto/4.1.0/Crypto-4.1.0.tar.gz";
                                            sha256 = "13rbpbn6p1da6qa9m6f7dmkzdkmpnx6jiyyndzaz99nzqlrwi109"; };
                     };
          hslogger = rec { name = "hslogger-1.0.4"; p_deps = [ x.containers x.directory x.mtl x.network x.process];
                           src = fetchurl { url = "http://hackage.haskell.org/packages/archive/hslogger/1.0.4/hslogger-1.0.4.tar.gz";
                                            sha256 = "0kmz8xs1q41rg2xwk22fadyhxdg5mizhw0r4d74y43akkjwj96ar"; };
                     };
          parsep = { name = "parsep-0.1"; p_deps = [ x.base x.mtl x.bytestring ];
                             src = fetchurl { url = "http://twan.home.fmf.nl/parsep/parsep-0.1.tar.gz";
                                            sha256 = "1y5pbs5mzaa21127cixsamahlbvmqzyhzpwh6x0nznsgmg2dpc9q"; };
                             pass = { patchPhase = "sed -i 's/fps/bytestring/' *.cabal"; };
                     };
          time = { name = "time-1.1.2.0"; p_deps = [ x.base x.old_locale ];
                             src = fetchurl { url = "http://hackage.haskell.org/packages/archive/time/1.1.2.0/time-1.1.2.0.tar.gz";
                                            sha256 = "0zm4qqczwbqzy2pk7wz5p1virgylwyzd9zxp0406s5zvp35gvl89"; };
                      };
          rjson = { name = "RJson-0.3.3"; p_deps = [ x.base x.mtl x.parsec3 x.bytestring x.iconv x.array x.containers x.syb_with_class_darcs ];
                            src = fetchurl { url = http://hackage.haskell.org/packages/archive/RJson/0.3.3/RJson-0.3.3.tar.gz;
                                            sha256 = "0va1rbgjb8m3rij02318a31bi9gmy3zwyx5z12164c7iwafnd5v2"; };
                      };
          iconv = { name = "iconv-0.4"; p_deps = [ x.base x.bytestring ];
                            src = fetchurl { url = http://hackage.haskell.org/packages/archive/iconv/0.4/iconv-0.4.tar.gz;
                                            sha256 = "1snqzz7hi2qa83m5v3098rsldb485kz2jggd335qhvjahcp4bj1p"; };
                      };

          utf8string = { name = "utf8-string-0.3"; p_deps = [ x.base x.bytestring ];
                            src = fetchurl { url = http://hackage.haskell.org/packages/archive/utf8-string/0.3/utf8-string-0.3.tar.gz;
                                            sha256 = "11mln2r0ym4y12zxizn6n40xbgsi6q4n6n810rcg94bv35gqgcby"; };
                      };
          x11 = { name = "x11-1.4.1"; p_deps = [ x.base x.haskell98 x.bytestring ] ++ (with xlibs; [ libX11 libXext ]);
                            src = fetchurl { url = http://hackage.haskell.org/packages/archive/X11/1.4.1/X11-1.4.1.tar.gz;
                                            sha256 = "0yczl1m7g3lggcxh56fy2br13kbk4c5vrkcc4w76ys0m2ia3h475"; };
                      };
          x11extras = { name = "X11-extras-0.4"; p_deps = [ x.base x.bytestring x.x11 xlibs.libXinerama ];
                            src = fetchurl { url = http://hackage.haskell.org/packages/archive/X11-extras/0.4/X11-extras-0.4.tar.gz;
                                            sha256 = "1cpjr09gddcjd0wqwvaankv1zj7fyc6hbfdvar63f51g3vvw627a"; };
                      };
              /*
          x11xft = { name = "xft-0.2"; p_deps = [ x.base x.bytestring x.haskell98 x.x11 x.utf8string x.bytestring xlibs.libXft freetype];
                            src = fetchurl { url = http://hackage.haskell.org/packages/archive/X11-xft/0.2/X11-xft-0.2.tar.gz;
                                            sha256 = "1ahvpkgh5mr6v8gisv1sc9s4075hqh85cpqcqh1ylr6lkf7dz31w"; };
                             pass = {
                                inherit freetype;
                                patchPhase = "sed -i \"s=include-dirs:.*=include-dirs: $freetype/include=\" *.cabal"; };
                      };
              */

          # HAPPS - Libraries
          http_darcs = { name="http-darcs"; p_deps = [x.network x.parsec3];
                      src = sourceByName "http";
                       #src = fetchdarcs { url = "http://darcs.haskell.org/http/"; md5 = "4475f858cf94f4551b77963d08d7257c"; };
                     };
          syb_with_class_darcs = { name="syb-with-class-darcs"; p_deps = [x.template_haskell x.bytestring ];
                       src =
                        # fetchdarcs { url = "http://happs.org/HAppS/syb-with-class"; md5 = "b42336907f7bfef8bea73bc36282d6ac"; };
                         sourceByName "syb_with_class"; # { url = "http://happs.org/HAppS/syb-with-class"; md5 = "b42336907f7bfef8bea73bc36282d6ac"; };
                     };

          happs_data_darcs = { name="HAppS-Data-darcs"; p_deps=[ x.base x.mtl x.template_haskell x.syb_with_class_darcs x.haxml x.happs_util_darcs x.regex_compat x.bytestring x.pretty x.binary ];
                        src = sourceByName "happs_data"; # fetchdarcs { url = "http://happs.org/repos/HAppS-Data"; md5 = "10c505dd687e9dc999cb187090af9ba7"; };
                        };
          happs_util_darcs = { name="HAppS-Util-darcs"; p_deps=[ x.base x.mtl x.hslogger x.template_haskell x.array x.bytestring x.old_time x.process x.directory ];
                        src = sourceByName "happs_util"; # fetchdarcs { url = "http://happs.org/repos/HAppS-Util"; md5 = "693cb79017e522031c307ee5e59fc250"; };
                        };

          happs_state_darcs = { name="HAppS-State-darcs"; p_deps=[ x.base x.haxml
                          x.mtl x.network x.stm x.template_haskell x.hslogger
                            x.happs_util_darcs x.happs_data_darcs x.bytestring x.containers
                            x.random x.old_time x.old_locale x.unix x.directory x.binary x.hspread ];
                          src = sourceByName "happs_state";
                          #src = fetchdarcs { url = "http://happs.org/repos/HAppS-State";
                          #                   md5 = "956e5c293b60f4a98148fedc5fa38acc";
                          #                 };
                        };


          happs_hsp_darcs = { name="happs-hsp-darcs"; src=sourceByName "happs_hsp"; p_deps=[x.base x.mtl x.bytestring x.plugins_darcs x.happs_server_darcs x.hsp_darcs x.containers x.rjson x.directory x.hinotify x.filepath];
            pass = { patches = ./hsp-darcs.patch; };
          };
          happs_hsp_template_darcs = { name="happs-hsp-template-darcs"; src=sourceByName "happs_hsp_template"; p_deps=[ x.base x.bytestring x.filepath x.directory x.mtl x.containers x.network x.hinotify x.plugins_darcs x.rjson x.happs_server_darcs x.hsp_darcs]; };
          hsp_darcs = { name="hsp-darcs"; src=sourceByName "hsp"; p_deps=[x.base x.mtl x.harp x.hsx x.hjscript_darcs];
                pass = { inherit (x) hsx; postUnpack=''PATH=$PATH:$hsx/usr/local/bin''; };
                };
          #hsp_xml_darcs = { name="hsp-xml-darcs"; src=sourceByName "hsp_xml"; p_deps=[x.base x.haskell98 x.hsp_darcs x.hsx x.mtl x.harp x.haxml_darcs];
          #      pass = { inherit (x) hsx; postUnpack=''PATH=$PATH:$hsx/usr/local/bin''; };
          #  };
          hspCgi_darcs = { name="hsp-cgi-darcs"; src=sourceByName "hspCgi"; p_deps=[x.base x.hsp_darcs x.network x.containers x.harp];
                pass = { inherit (x) hsx; postUnpack=''PATH=$PATH:$hsx/usr/local/bin''; };
            };
          hjscript_darcs = { name="hjscript-darcs"; src=sourceByName "hjscript"; p_deps=[x.base x.hjavascript_darcs x.mtl x.hsx]; };
          hjquery_darcs = { name="hjquery-darcs"; src=sourceByName "hjquery"; p_deps=[x.base x.hjscript_darcs ]; };
          hjavascript_darcs = { name="darcs"; src=sourceByName "hjavascript"; p_deps=[x.base x.pretty]; };

           #happs_plugins_darcs = { name="HAppS-plugins-darcs"; p_deps=[ x.base x.mtl x.hslogger x.happs_util_darcs x.happs_data_darcs x.happs_state_darcs x.containers ];
                       #src = bleedingEdgeRepos.sourceByName "happs_plugins";
                       #};
            # there is no .cabal yet
            #happs_smtp_darcs = { name="HAppS-smtp-darcs"; p_deps=[];
                        #src = fetchdarcs { url = "http://happs.org/repos/HAppS-smtp"; md5 = "5316917e271ea1ed8ad261080bcb47db"; };
                        #};

          happs_ixset_darcs = { name="HAppS-IxSet-darcs"; p_deps=[ x.base x.mtl
                              x.hslogger x.happs_util_darcs x.happs_state_darcs x.happs_data_darcs
                              x.template_haskell x.syb_with_class_darcs x.containers ];
                        src = sourceByName "happs_ixset";
                        };
          happs_server_darcs = { name="HAppS-Server-darcs"; p_deps=[x.haxml x.parsec3 x.mtl
                    x.network x.regex_compat x.hslogger x.happs_data_darcs
                      x.happs_util_darcs x.happs_state_darcs x.happs_ixset_darcs x.http_darcs
                      x.template_haskell x.xhtml x.html x.bytestring x.random
                      x.containers x.old_time x.old_locale x.directory x.unix];
                        #src = fetchdarcs { url = "http://happs.org/repos/HAppS-HTTP"; md5 = "e1bb17eb30a39d30b8c34dffbf80edc2"; };
                        src = sourceByName "happs_server";
                        };
            # using darcs with minimal patch applied to support $GHC_PACKAGE_PATH
           cabal_darcs =
            { name=cabal_darcs_name; p_deps = with ghc.core_libs; [base rts directory process pretty containers filepath];
                      src = sourceByName "cabal";
              pass = { dummy = 2; };
            };
      } // (getConfig [ "ghc68CustomLibs" ] ( args: x : {} ) ) args x;
      toDerivation = attrs : with attrs;
      # result is { mtl = <deriv>;
        addHasktagsTaggingInfo (ghcCabalDerivation {
            inherit (attrs) name src;
            useLocalPkgDB = attrs ? useLocalPkgDB;
            propagatedBuildInputs = p_deps ++ (lib.optional (attrs.name != cabal_darcs_name) derivations.cabal_darcs );
            srcDir = if attrs ? srcDir then attrs.srcDir else ".";
            # add cabal, take deps either from this list or from ghc.core_libs
            pass = if attrs ? pass then attrs.pass else {};
        });
      derivations = with lib; builtins.listToAttrs (lib.concatLists ( lib.mapRecordFlatten
                ( n : attrs : let d = (toDerivation attrs); in [ (nv n d) (nv attrs.name d) ] ) pkgs ) );
    }.derivations
