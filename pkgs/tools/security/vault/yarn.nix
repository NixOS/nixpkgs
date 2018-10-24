{fetchurl, linkFarm}: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [

    {
      name = "jquery-0.5.2.tgz";
      path = fetchurl {
        name = "jquery-0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/@ember/jquery/-/jquery-0.5.2.tgz";
        sha1 = "fe312c03ada0022fa092d23f7cd7e2eb0374b53a";
      };
    }

    {
      name = "optional-features-0.6.4.tgz";
      path = fetchurl {
        name = "optional-features-0.6.4.tgz";
        url  = "https://registry.yarnpkg.com/@ember/optional-features/-/optional-features-0.6.4.tgz";
        sha1 = "8199f853c1781234fcb1f05090cddd0b822bff69";
      };
    }

    {
      name = "ordered-set-2.0.0.tgz";
      path = fetchurl {
        name = "ordered-set-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@ember/ordered-set/-/ordered-set-2.0.0.tgz";
        sha1 = "54f34aba3a1fb75b7c2912a39ab41a4a2e9d266d";
      };
    }

    {
      name = "test-helpers-0.7.25.tgz";
      path = fetchurl {
        name = "test-helpers-0.7.25.tgz";
        url  = "https://registry.yarnpkg.com/@ember/test-helpers/-/test-helpers-0.7.25.tgz";
        sha1 = "b4014c108b40ffaf74f3c4d5918800917541541d";
      };
    }

    {
      name = "compiler-0.36.2.tgz";
      path = fetchurl {
        name = "compiler-0.36.2.tgz";
        url  = "https://registry.yarnpkg.com/@glimmer/compiler/-/compiler-0.36.2.tgz";
        sha1 = "c44e08e9795e2c003a54ec605c70870aa61cb6df";
      };
    }

    {
      name = "di-0.2.1.tgz";
      path = fetchurl {
        name = "di-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/@glimmer/di/-/di-0.2.1.tgz";
        sha1 = "5286b6b32040232b751138f6d006130c728d4b3d";
      };
    }

    {
      name = "interfaces-0.36.2.tgz";
      path = fetchurl {
        name = "interfaces-0.36.2.tgz";
        url  = "https://registry.yarnpkg.com/@glimmer/interfaces/-/interfaces-0.36.2.tgz";
        sha1 = "04e2542d06e08cce2e243a9870e0c97edb512f87";
      };
    }

    {
      name = "resolver-0.4.3.tgz";
      path = fetchurl {
        name = "resolver-0.4.3.tgz";
        url  = "https://registry.yarnpkg.com/@glimmer/resolver/-/resolver-0.4.3.tgz";
        sha1 = "b1baae5c3291b4621002ccf8d7870466097e841d";
      };
    }

    {
      name = "syntax-0.36.2.tgz";
      path = fetchurl {
        name = "syntax-0.36.2.tgz";
        url  = "https://registry.yarnpkg.com/@glimmer/syntax/-/syntax-0.36.2.tgz";
        sha1 = "86b294693c57ba8a28bfadeb4c09391f2dbf09b7";
      };
    }

    {
      name = "util-0.36.2.tgz";
      path = fetchurl {
        name = "util-0.36.2.tgz";
        url  = "https://registry.yarnpkg.com/@glimmer/util/-/util-0.36.2.tgz";
        sha1 = "6c0f99d0235659969bacffa47f8104f82b28fabe";
      };
    }

    {
      name = "wire-format-0.36.2.tgz";
      path = fetchurl {
        name = "wire-format-0.36.2.tgz";
        url  = "https://registry.yarnpkg.com/@glimmer/wire-format/-/wire-format-0.36.2.tgz";
        sha1 = "49891cc237baa90059d87cb480ec021820bcbfc5";
      };
    }

    {
      name = "js-lib-semantic-release-config-0.0.0-development.tgz";
      path = fetchurl {
        name = "js-lib-semantic-release-config-0.0.0-development.tgz";
        url  = "https://registry.yarnpkg.com/@mike-north/js-lib-semantic-release-config/-/js-lib-semantic-release-config-0.0.0-development.tgz";
        sha1 = "b3c0f8972036c74dea94208a7f57b5d3a2f7dc1b";
      };
    }

    {
      name = "readdir-enhanced-2.2.1.tgz";
      path = fetchurl {
        name = "readdir-enhanced-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/@mrmlnc/readdir-enhanced/-/readdir-enhanced-2.2.1.tgz";
        sha1 = "524af240d1a360527b730475ecfa1344aa540dde";
      };
    }

    {
      name = "fs.stat-1.1.2.tgz";
      path = fetchurl {
        name = "fs.stat-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-1.1.2.tgz";
        sha1 = "54c5a964462be3d4d78af631363c18d6fa91ac26";
      };
    }

    {
      name = "rest-15.11.1.tgz";
      path = fetchurl {
        name = "rest-15.11.1.tgz";
        url  = "https://registry.yarnpkg.com/@octokit/rest/-/rest-15.11.1.tgz";
        sha1 = "ef4e7462ec8f94e535a82220f7b5212111fc2647";
      };
    }

    {
      name = "changelog-3.0.0.tgz";
      path = fetchurl {
        name = "changelog-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@semantic-release/changelog/-/changelog-3.0.0.tgz";
        sha1 = "e01514b517e775cea47aef7df5f5685c7aff2bf2";
      };
    }

    {
      name = "commit-analyzer-6.0.0.tgz";
      path = fetchurl {
        name = "commit-analyzer-6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@semantic-release/commit-analyzer/-/commit-analyzer-6.0.0.tgz";
        sha1 = "e26ef70938059f03525573560f65212164953121";
      };
    }

    {
      name = "error-2.2.0.tgz";
      path = fetchurl {
        name = "error-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@semantic-release/error/-/error-2.2.0.tgz";
        sha1 = "ee9d5a09c9969eade1ec864776aeda5c5cddbbf0";
      };
    }

    {
      name = "exec-3.1.2.tgz";
      path = fetchurl {
        name = "exec-3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/@semantic-release/exec/-/exec-3.1.2.tgz";
        sha1 = "4ed89e5422d02aca9b86fbfd318d230cd29b7065";
      };
    }

    {
      name = "git-7.0.3.tgz";
      path = fetchurl {
        name = "git-7.0.3.tgz";
        url  = "https://registry.yarnpkg.com/@semantic-release/git/-/git-7.0.3.tgz";
        sha1 = "758ffbb0156e236f1d731c5d36e2bbf46a8098f2";
      };
    }

    {
      name = "github-5.0.4.tgz";
      path = fetchurl {
        name = "github-5.0.4.tgz";
        url  = "https://registry.yarnpkg.com/@semantic-release/github/-/github-5.0.4.tgz";
        sha1 = "09a870e3fb7ccd1a3eedc4d72a7f0a33c1dce794";
      };
    }

    {
      name = "npm-5.0.4.tgz";
      path = fetchurl {
        name = "npm-5.0.4.tgz";
        url  = "https://registry.yarnpkg.com/@semantic-release/npm/-/npm-5.0.4.tgz";
        sha1 = "bef4ff31c9a70cc6db7583e08d2d29741b32d2f8";
      };
    }

    {
      name = "release-notes-generator-7.0.1.tgz";
      path = fetchurl {
        name = "release-notes-generator-7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/@semantic-release/release-notes-generator/-/release-notes-generator-7.0.1.tgz";
        sha1 = "300c06b56e965a0aec5d7a83f164b0d7e497ea7b";
      };
    }

    {
      name = "formatio-2.0.0.tgz";
      path = fetchurl {
        name = "formatio-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@sinonjs/formatio/-/formatio-2.0.0.tgz";
        sha1 = "84db7e9eb5531df18a8c5e0bfb6e449e55e654b2";
      };
    }

    {
      name = "acorn-4.0.3.tgz";
      path = fetchurl {
        name = "acorn-4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/acorn/-/acorn-4.0.3.tgz";
        sha1 = "d1f3e738dde52536f9aad3d3380d14e448820afd";
      };
    }

    {
      name = "estree-0.0.39.tgz";
      path = fetchurl {
        name = "estree-0.0.39.tgz";
        url  = "https://registry.yarnpkg.com/@types/estree/-/estree-0.0.39.tgz";
        sha1 = "e177e699ee1b8c22d23174caaa7422644389509f";
      };
    }

    {
      name = "estree-0.0.38.tgz";
      path = fetchurl {
        name = "estree-0.0.38.tgz";
        url  = "https://registry.yarnpkg.com/@types/estree/-/estree-0.0.38.tgz";
        sha1 = "c1be40aa933723c608820a99a373a16d215a1ca2";
      };
    }

    {
      name = "node-9.6.31.tgz";
      path = fetchurl {
        name = "node-9.6.31.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-9.6.31.tgz";
        sha1 = "4d1722987f8d808b4c194dceb8c213bd92f028e5";
      };
    }

    {
      name = "ast-1.5.13.tgz";
      path = fetchurl {
        name = "ast-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/ast/-/ast-1.5.13.tgz";
        sha1 = "81155a570bd5803a30ec31436bc2c9c0ede38f25";
      };
    }

    {
      name = "floating-point-hex-parser-1.5.13.tgz";
      path = fetchurl {
        name = "floating-point-hex-parser-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.5.13.tgz";
        sha1 = "29ce0baa97411f70e8cce68ce9c0f9d819a4e298";
      };
    }

    {
      name = "helper-api-error-1.5.13.tgz";
      path = fetchurl {
        name = "helper-api-error-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-api-error/-/helper-api-error-1.5.13.tgz";
        sha1 = "e49b051d67ee19a56e29b9aa8bd949b5b4442a59";
      };
    }

    {
      name = "helper-buffer-1.5.13.tgz";
      path = fetchurl {
        name = "helper-buffer-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-buffer/-/helper-buffer-1.5.13.tgz";
        sha1 = "873bb0a1b46449231137c1262ddfd05695195a1e";
      };
    }

    {
      name = "helper-code-frame-1.5.13.tgz";
      path = fetchurl {
        name = "helper-code-frame-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-code-frame/-/helper-code-frame-1.5.13.tgz";
        sha1 = "1bd2181b6a0be14e004f0fe9f5a660d265362b58";
      };
    }

    {
      name = "helper-fsm-1.5.13.tgz";
      path = fetchurl {
        name = "helper-fsm-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-fsm/-/helper-fsm-1.5.13.tgz";
        sha1 = "cdf3d9d33005d543a5c5e5adaabf679ffa8db924";
      };
    }

    {
      name = "helper-module-context-1.5.13.tgz";
      path = fetchurl {
        name = "helper-module-context-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-module-context/-/helper-module-context-1.5.13.tgz";
        sha1 = "dc29ddfb51ed657655286f94a5d72d8a489147c5";
      };
    }

    {
      name = "helper-wasm-bytecode-1.5.13.tgz";
      path = fetchurl {
        name = "helper-wasm-bytecode-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.5.13.tgz";
        sha1 = "03245817f0a762382e61733146f5773def15a747";
      };
    }

    {
      name = "helper-wasm-section-1.5.13.tgz";
      path = fetchurl {
        name = "helper-wasm-section-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.5.13.tgz";
        sha1 = "efc76f44a10d3073b584b43c38a179df173d5c7d";
      };
    }

    {
      name = "ieee754-1.5.13.tgz";
      path = fetchurl {
        name = "ieee754-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/ieee754/-/ieee754-1.5.13.tgz";
        sha1 = "573e97c8c12e4eebb316ca5fde0203ddd90b0364";
      };
    }

    {
      name = "leb128-1.5.13.tgz";
      path = fetchurl {
        name = "leb128-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/leb128/-/leb128-1.5.13.tgz";
        sha1 = "ab52ebab9cec283c1c1897ac1da833a04a3f4cee";
      };
    }

    {
      name = "utf8-1.5.13.tgz";
      path = fetchurl {
        name = "utf8-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/utf8/-/utf8-1.5.13.tgz";
        sha1 = "6b53d2cd861cf94fa99c1f12779dde692fbc2469";
      };
    }

    {
      name = "wasm-edit-1.5.13.tgz";
      path = fetchurl {
        name = "wasm-edit-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wasm-edit/-/wasm-edit-1.5.13.tgz";
        sha1 = "c9cef5664c245cf11b3b3a73110c9155831724a8";
      };
    }

    {
      name = "wasm-gen-1.5.13.tgz";
      path = fetchurl {
        name = "wasm-gen-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wasm-gen/-/wasm-gen-1.5.13.tgz";
        sha1 = "8e6ea113c4b432fa66540189e79b16d7a140700e";
      };
    }

    {
      name = "wasm-opt-1.5.13.tgz";
      path = fetchurl {
        name = "wasm-opt-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wasm-opt/-/wasm-opt-1.5.13.tgz";
        sha1 = "147aad7717a7ee4211c36b21a5f4c30dddf33138";
      };
    }

    {
      name = "wasm-parser-1.5.13.tgz";
      path = fetchurl {
        name = "wasm-parser-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wasm-parser/-/wasm-parser-1.5.13.tgz";
        sha1 = "6f46516c5bb23904fbdf58009233c2dd8a54c72f";
      };
    }

    {
      name = "wast-parser-1.5.13.tgz";
      path = fetchurl {
        name = "wast-parser-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wast-parser/-/wast-parser-1.5.13.tgz";
        sha1 = "5727a705d397ae6a3ae99d7f5460acf2ec646eea";
      };
    }

    {
      name = "wast-printer-1.5.13.tgz";
      path = fetchurl {
        name = "wast-printer-1.5.13.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wast-printer/-/wast-printer-1.5.13.tgz";
        sha1 = "bb34d528c14b4f579e7ec11e793ec50ad7cd7c95";
      };
    }

    {
      name = "cb1c58efc2772ef0f261da9e2535890734a86417";
      path = fetchurl {
        name = "cb1c58efc2772ef0f261da9e2535890734a86417";
        url  = "https://codeload.github.com/icholy/Duration.js/tar.gz/cb1c58efc2772ef0f261da9e2535890734a86417";
        sha1 = "cb52be3c1b0d5073d2d06f4bf0b9d7f5c53ee925";
      };
    }

    {
      name = "JSONStream-1.3.4.tgz";
      path = fetchurl {
        name = "JSONStream-1.3.4.tgz";
        url  = "https://registry.yarnpkg.com/JSONStream/-/JSONStream-1.3.4.tgz";
        sha1 = "615bb2adb0cd34c8f4c447b5f6512fa1d8f16a2e";
      };
    }

    {
      name = "JSV-4.0.2.tgz";
      path = fetchurl {
        name = "JSV-4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/JSV/-/JSV-4.0.2.tgz";
        sha1 = "d077f6825571f82132f9dffaed587b4029feff57";
      };
    }

    {
      name = "abab-2.0.0.tgz";
      path = fetchurl {
        name = "abab-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/abab/-/abab-2.0.0.tgz";
        sha1 = "aba0ab4c5eee2d4c79d3487d85450fb2376ebb0f";
      };
    }

    {
      name = "abbrev-1.1.1.tgz";
      path = fetchurl {
        name = "abbrev-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz";
        sha1 = "f8f2c887ad10bf67f634f005b6987fed3179aac8";
      };
    }

    {
      name = "accepts-1.3.5.tgz";
      path = fetchurl {
        name = "accepts-1.3.5.tgz";
        url  = "https://registry.yarnpkg.com/accepts/-/accepts-1.3.5.tgz";
        sha1 = "eb777df6011723a3b14e8a72c0805c8e86746bd2";
      };
    }

    {
      name = "acorn-dynamic-import-3.0.0.tgz";
      path = fetchurl {
        name = "acorn-dynamic-import-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn-dynamic-import/-/acorn-dynamic-import-3.0.0.tgz";
        sha1 = "901ceee4c7faaef7e07ad2a47e890675da50a278";
      };
    }

    {
      name = "acorn-globals-4.1.0.tgz";
      path = fetchurl {
        name = "acorn-globals-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn-globals/-/acorn-globals-4.1.0.tgz";
        sha1 = "ab716025dbe17c54d3ef81d32ece2b2d99fe2538";
      };
    }

    {
      name = "acorn-jsx-3.0.1.tgz";
      path = fetchurl {
        name = "acorn-jsx-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-3.0.1.tgz";
        sha1 = "afdf9488fb1ecefc8348f6fb22f464e32a58b36b";
      };
    }

    {
      name = "acorn-3.3.0.tgz";
      path = fetchurl {
        name = "acorn-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-3.3.0.tgz";
        sha1 = "45e37fb39e8da3f25baee3ff5369e2bb5f22017a";
      };
    }

    {
      name = "acorn-5.7.2.tgz";
      path = fetchurl {
        name = "acorn-5.7.2.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-5.7.2.tgz";
        sha1 = "91fa871883485d06708800318404e72bfb26dcc5";
      };
    }

    {
      name = "after-0.8.2.tgz";
      path = fetchurl {
        name = "after-0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/after/-/after-0.8.2.tgz";
        sha1 = "fedb394f9f0e02aa9768e702bda23b505fae7e1f";
      };
    }

    {
      name = "agent-base-4.2.1.tgz";
      path = fetchurl {
        name = "agent-base-4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/agent-base/-/agent-base-4.2.1.tgz";
        sha1 = "d89e5999f797875674c07d87f260fc41e83e8ca9";
      };
    }

    {
      name = "agentkeepalive-3.5.1.tgz";
      path = fetchurl {
        name = "agentkeepalive-3.5.1.tgz";
        url  = "https://registry.yarnpkg.com/agentkeepalive/-/agentkeepalive-3.5.1.tgz";
        sha1 = "4eba75cf2ad258fc09efd506cdb8d8c2971d35a4";
      };
    }

    {
      name = "aggregate-error-1.0.0.tgz";
      path = fetchurl {
        name = "aggregate-error-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-1.0.0.tgz";
        sha1 = "888344dad0220a72e3af50906117f48771925fac";
      };
    }

    {
      name = "ajv-keywords-2.1.1.tgz";
      path = fetchurl {
        name = "ajv-keywords-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-2.1.1.tgz";
        sha1 = "617997fc5f60576894c435f940d819e135b80762";
      };
    }

    {
      name = "ajv-keywords-3.2.0.tgz";
      path = fetchurl {
        name = "ajv-keywords-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.2.0.tgz";
        sha1 = "e86b819c602cf8821ad637413698f1dec021847a";
      };
    }

    {
      name = "ajv-5.5.2.tgz";
      path = fetchurl {
        name = "ajv-5.5.2.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-5.5.2.tgz";
        sha1 = "73b5eeca3fab653e3d3f9422b341ad42205dc965";
      };
    }

    {
      name = "ajv-6.5.3.tgz";
      path = fetchurl {
        name = "ajv-6.5.3.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-6.5.3.tgz";
        sha1 = "71a569d189ecf4f4f321224fecb166f071dd90f9";
      };
    }

    {
      name = "amd-name-resolver-1.2.0.tgz";
      path = fetchurl {
        name = "amd-name-resolver-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/amd-name-resolver/-/amd-name-resolver-1.2.0.tgz";
        sha1 = "fc41b3848824b557313897d71f8d5a0184fbe679";
      };
    }

    {
      name = "amdefine-1.0.1.tgz";
      path = fetchurl {
        name = "amdefine-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/amdefine/-/amdefine-1.0.1.tgz";
        sha1 = "4a5282ac164729e93619bcfd3ad151f817ce91f5";
      };
    }

    {
      name = "ansi-align-2.0.0.tgz";
      path = fetchurl {
        name = "ansi-align-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-align/-/ansi-align-2.0.0.tgz";
        sha1 = "c36aeccba563b89ceb556f3690f0b1d9e3547f7f";
      };
    }

    {
      name = "ansi-escapes-1.4.0.tgz";
      path = fetchurl {
        name = "ansi-escapes-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-1.4.0.tgz";
        sha1 = "d3a8a83b319aa67793662b13e761c7911422306e";
      };
    }

    {
      name = "ansi-escapes-3.1.0.tgz";
      path = fetchurl {
        name = "ansi-escapes-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-3.1.0.tgz";
        sha1 = "f73207bb81207d75fd6c83f125af26eea378ca30";
      };
    }

    {
      name = "ansi-regex-2.1.1.tgz";
      path = fetchurl {
        name = "ansi-regex-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz";
        sha1 = "c3b33ab5ee360d86e0e628f0468ae7ef27d654df";
      };
    }

    {
      name = "ansi-regex-3.0.0.tgz";
      path = fetchurl {
        name = "ansi-regex-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-3.0.0.tgz";
        sha1 = "ed0317c322064f79466c02966bddb605ab37d998";
      };
    }

    {
      name = "ansi-styles-2.2.1.tgz";
      path = fetchurl {
        name = "ansi-styles-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-2.2.1.tgz";
        sha1 = "b432dd3358b634cf75e1e4664368240533c1ddbe";
      };
    }

    {
      name = "ansi-styles-3.2.1.tgz";
      path = fetchurl {
        name = "ansi-styles-3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz";
        sha1 = "41fbb20243e50b12be0f04b8dedbf07520ce841d";
      };
    }

    {
      name = "ansi-styles-1.0.0.tgz";
      path = fetchurl {
        name = "ansi-styles-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-1.0.0.tgz";
        sha1 = "cb102df1c56f5123eab8b67cd7b98027a0279178";
      };
    }

    {
      name = "ansicolors-0.2.1.tgz";
      path = fetchurl {
        name = "ansicolors-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ansicolors/-/ansicolors-0.2.1.tgz";
        sha1 = "be089599097b74a5c9c4a84a0cdbcdb62bd87aef";
      };
    }

    {
      name = "ansicolors-0.3.2.tgz";
      path = fetchurl {
        name = "ansicolors-0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/ansicolors/-/ansicolors-0.3.2.tgz";
        sha1 = "665597de86a9ffe3aa9bfbe6cae5c6ea426b4979";
      };
    }

    {
      name = "ansistyles-0.1.3.tgz";
      path = fetchurl {
        name = "ansistyles-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/ansistyles/-/ansistyles-0.1.3.tgz";
        sha1 = "5de60415bda071bb37127854c864f41b23254539";
      };
    }

    {
      name = "anymatch-2.0.0.tgz";
      path = fetchurl {
        name = "anymatch-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/anymatch/-/anymatch-2.0.0.tgz";
        sha1 = "bcb24b4f37934d9aa7ac17b4adaf89e7c76ef2eb";
      };
    }

    {
      name = "aot-test-generators-0.1.0.tgz";
      path = fetchurl {
        name = "aot-test-generators-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/aot-test-generators/-/aot-test-generators-0.1.0.tgz";
        sha1 = "43f0f615f97cb298d7919c1b0b4e6b7310b03cd0";
      };
    }

    {
      name = "applause-1.2.2.tgz";
      path = fetchurl {
        name = "applause-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/applause/-/applause-1.2.2.tgz";
        sha1 = "a8468579e81f67397bb5634c29953bedcd0f56c0";
      };
    }

    {
      name = "aproba-1.2.0.tgz";
      path = fetchurl {
        name = "aproba-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/aproba/-/aproba-1.2.0.tgz";
        sha1 = "6802e6264efd18c790a1b0d517f0f2627bf2c94a";
      };
    }

    {
      name = "aproba-2.0.0.tgz";
      path = fetchurl {
        name = "aproba-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/aproba/-/aproba-2.0.0.tgz";
        sha1 = "52520b8ae5b569215b354efc0caa3fe1e45a8adc";
      };
    }

    {
      name = "archy-1.0.0.tgz";
      path = fetchurl {
        name = "archy-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/archy/-/archy-1.0.0.tgz";
        sha1 = "f9c8c13757cc1dd7bc379ac77b2c62a5c2868c40";
      };
    }

    {
      name = "are-we-there-yet-1.1.5.tgz";
      path = fetchurl {
        name = "are-we-there-yet-1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-1.1.5.tgz";
        sha1 = "4b35c2944f062a8bfcda66410760350fe9ddfc21";
      };
    }

    {
      name = "argparse-1.0.10.tgz";
      path = fetchurl {
        name = "argparse-1.0.10.tgz";
        url  = "https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz";
        sha1 = "bcd6791ea5ae09725e17e5ad988134cd40b3d911";
      };
    }

    {
      name = "argv-formatter-1.0.0.tgz";
      path = fetchurl {
        name = "argv-formatter-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/argv-formatter/-/argv-formatter-1.0.0.tgz";
        sha1 = "a0ca0cbc29a5b73e836eebe1cbf6c5e0e4eb82f9";
      };
    }

    {
      name = "arr-diff-2.0.0.tgz";
      path = fetchurl {
        name = "arr-diff-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/arr-diff/-/arr-diff-2.0.0.tgz";
        sha1 = "8f3b827f955a8bd669697e4a4256ac3ceae356cf";
      };
    }

    {
      name = "arr-diff-4.0.0.tgz";
      path = fetchurl {
        name = "arr-diff-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/arr-diff/-/arr-diff-4.0.0.tgz";
        sha1 = "d6461074febfec71e7e15235761a329a5dc7c520";
      };
    }

    {
      name = "arr-flatten-1.1.0.tgz";
      path = fetchurl {
        name = "arr-flatten-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.1.0.tgz";
        sha1 = "36048bbff4e7b47e136644316c99669ea5ae91f1";
      };
    }

    {
      name = "arr-union-3.1.0.tgz";
      path = fetchurl {
        name = "arr-union-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/arr-union/-/arr-union-3.1.0.tgz";
        sha1 = "e39b09aea9def866a8f206e288af63919bae39c4";
      };
    }

    {
      name = "array-equal-1.0.0.tgz";
      path = fetchurl {
        name = "array-equal-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/array-equal/-/array-equal-1.0.0.tgz";
        sha1 = "8c2a5ef2472fd9ea742b04c77a75093ba2757c93";
      };
    }

    {
      name = "array-find-index-1.0.2.tgz";
      path = fetchurl {
        name = "array-find-index-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/array-find-index/-/array-find-index-1.0.2.tgz";
        sha1 = "df010aa1287e164bbda6f9723b0a96a1ec4187a1";
      };
    }

    {
      name = "array-flatten-1.1.1.tgz";
      path = fetchurl {
        name = "array-flatten-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/array-flatten/-/array-flatten-1.1.1.tgz";
        sha1 = "9a5f699051b1e7073328f2a008968b64ea2955d2";
      };
    }

    {
      name = "array-ify-1.0.0.tgz";
      path = fetchurl {
        name = "array-ify-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/array-ify/-/array-ify-1.0.0.tgz";
        sha1 = "9e528762b4a9066ad163a6962a364418e9626ece";
      };
    }

    {
      name = "array-to-error-1.1.1.tgz";
      path = fetchurl {
        name = "array-to-error-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/array-to-error/-/array-to-error-1.1.1.tgz";
        sha1 = "d68812926d14097a205579a667eeaf1856a44c07";
      };
    }

    {
      name = "array-to-sentence-1.1.0.tgz";
      path = fetchurl {
        name = "array-to-sentence-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/array-to-sentence/-/array-to-sentence-1.1.0.tgz";
        sha1 = "c804956dafa53232495b205a9452753a258d39fc";
      };
    }

    {
      name = "array-union-1.0.2.tgz";
      path = fetchurl {
        name = "array-union-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/array-union/-/array-union-1.0.2.tgz";
        sha1 = "9a34410e4f4e3da23dea375be5be70f24778ec39";
      };
    }

    {
      name = "array-uniq-1.0.3.tgz";
      path = fetchurl {
        name = "array-uniq-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/array-uniq/-/array-uniq-1.0.3.tgz";
        sha1 = "af6ac877a25cc7f74e058894753858dfdb24fdb6";
      };
    }

    {
      name = "array-unique-0.2.1.tgz";
      path = fetchurl {
        name = "array-unique-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/array-unique/-/array-unique-0.2.1.tgz";
        sha1 = "a1d97ccafcbc2625cc70fadceb36a50c58b01a53";
      };
    }

    {
      name = "array-unique-0.3.2.tgz";
      path = fetchurl {
        name = "array-unique-0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/array-unique/-/array-unique-0.3.2.tgz";
        sha1 = "a894b75d4bc4f6cd679ef3244a9fd8f46ae2d428";
      };
    }

    {
      name = "arraybuffer.slice-0.0.7.tgz";
      path = fetchurl {
        name = "arraybuffer.slice-0.0.7.tgz";
        url  = "https://registry.yarnpkg.com/arraybuffer.slice/-/arraybuffer.slice-0.0.7.tgz";
        sha1 = "3bbc4275dd584cc1b10809b89d4e8b63a69e7675";
      };
    }

    {
      name = "arrify-1.0.1.tgz";
      path = fetchurl {
        name = "arrify-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/arrify/-/arrify-1.0.1.tgz";
        sha1 = "898508da2226f380df904728456849c1501a4b0d";
      };
    }

    {
      name = "asap-2.0.6.tgz";
      path = fetchurl {
        name = "asap-2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/asap/-/asap-2.0.6.tgz";
        sha1 = "e50347611d7e690943208bbdafebcbc2fb866d46";
      };
    }

    {
      name = "asn1.js-4.10.1.tgz";
      path = fetchurl {
        name = "asn1.js-4.10.1.tgz";
        url  = "https://registry.yarnpkg.com/asn1.js/-/asn1.js-4.10.1.tgz";
        sha1 = "b9c2bf5805f1e64aadeed6df3a2bfafb5a73f5a0";
      };
    }

    {
      name = "asn1-0.2.4.tgz";
      path = fetchurl {
        name = "asn1-0.2.4.tgz";
        url  = "https://registry.yarnpkg.com/asn1/-/asn1-0.2.4.tgz";
        sha1 = "8d2475dfab553bb33e77b54e59e880bb8ce23136";
      };
    }

    {
      name = "assert-plus-1.0.0.tgz";
      path = fetchurl {
        name = "assert-plus-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/assert-plus/-/assert-plus-1.0.0.tgz";
        sha1 = "f12e0f3c5d77b0b1cdd9146942e4e96c1e4dd525";
      };
    }

    {
      name = "assert-1.4.1.tgz";
      path = fetchurl {
        name = "assert-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/assert/-/assert-1.4.1.tgz";
        sha1 = "99912d591836b5a6f5b345c0f07eefc08fc65d91";
      };
    }

    {
      name = "assertion-error-1.0.0.tgz";
      path = fetchurl {
        name = "assertion-error-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/assertion-error/-/assertion-error-1.0.0.tgz";
        sha1 = "c7f85438fdd466bc7ca16ab90c81513797a5d23b";
      };
    }

    {
      name = "assign-symbols-1.0.0.tgz";
      path = fetchurl {
        name = "assign-symbols-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/assign-symbols/-/assign-symbols-1.0.0.tgz";
        sha1 = "59667f41fadd4f20ccbc2bb96b8d4f7f78ec0367";
      };
    }

    {
      name = "ast-types-0.9.6.tgz";
      path = fetchurl {
        name = "ast-types-0.9.6.tgz";
        url  = "https://registry.yarnpkg.com/ast-types/-/ast-types-0.9.6.tgz";
        sha1 = "102c9e9e9005d3e7e3829bf0c4fa24ee862ee9b9";
      };
    }

    {
      name = "async-disk-cache-1.3.3.tgz";
      path = fetchurl {
        name = "async-disk-cache-1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/async-disk-cache/-/async-disk-cache-1.3.3.tgz";
        sha1 = "6040486660b370e4051cd9fa9fee275e1fae3728";
      };
    }

    {
      name = "async-each-1.0.1.tgz";
      path = fetchurl {
        name = "async-each-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/async-each/-/async-each-1.0.1.tgz";
        sha1 = "19d386a1d9edc6e7c1c85d388aedbcc56d33602d";
      };
    }

    {
      name = "async-foreach-0.1.3.tgz";
      path = fetchurl {
        name = "async-foreach-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/async-foreach/-/async-foreach-0.1.3.tgz";
        sha1 = "36121f845c0578172de419a97dbeb1d16ec34542";
      };
    }

    {
      name = "async-limiter-1.0.0.tgz";
      path = fetchurl {
        name = "async-limiter-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/async-limiter/-/async-limiter-1.0.0.tgz";
        sha1 = "78faed8c3d074ab81f22b4e985d79e8738f720f8";
      };
    }

    {
      name = "async-promise-queue-1.0.4.tgz";
      path = fetchurl {
        name = "async-promise-queue-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/async-promise-queue/-/async-promise-queue-1.0.4.tgz";
        sha1 = "308baafbc74aff66a0bb6e7f4a18d4fe8434440c";
      };
    }

    {
      name = "async-1.5.2.tgz";
      path = fetchurl {
        name = "async-1.5.2.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-1.5.2.tgz";
        sha1 = "ec6a61ae56480c0c3cb241c95618e20892f9672a";
      };
    }

    {
      name = "async-2.6.1.tgz";
      path = fetchurl {
        name = "async-2.6.1.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-2.6.1.tgz";
        sha1 = "b245a23ca71930044ec53fa46aa00a3e87c6a610";
      };
    }

    {
      name = "async-0.2.10.tgz";
      path = fetchurl {
        name = "async-0.2.10.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-0.2.10.tgz";
        sha1 = "b6bbe0b0674b9d719708ca38de8c237cb526c3d1";
      };
    }

    {
      name = "asynckit-0.4.0.tgz";
      path = fetchurl {
        name = "asynckit-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz";
        sha1 = "c79ed97f7f34cb8f2ba1bc9790bcc366474b4b79";
      };
    }

    {
      name = "atob-2.1.2.tgz";
      path = fetchurl {
        name = "atob-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/atob/-/atob-2.1.2.tgz";
        sha1 = "6d9517eb9e030d2436666651e86bd9f6f13533c9";
      };
    }

    {
      name = "autoprefixer-7.2.6.tgz";
      path = fetchurl {
        name = "autoprefixer-7.2.6.tgz";
        url  = "http://registry.npmjs.org/autoprefixer/-/autoprefixer-7.2.6.tgz";
        sha1 = "256672f86f7c735da849c4f07d008abb056067dc";
      };
    }

    {
      name = "autosize-4.0.2.tgz";
      path = fetchurl {
        name = "autosize-4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/autosize/-/autosize-4.0.2.tgz";
        sha1 = "073cfd07c8bf45da4b9fd153437f5bafbba1e4c9";
      };
    }

    {
      name = "aws-sign2-0.7.0.tgz";
      path = fetchurl {
        name = "aws-sign2-0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/aws-sign2/-/aws-sign2-0.7.0.tgz";
        sha1 = "b46e890934a9591f2d2f6f86d7e6a9f1b3fe76a8";
      };
    }

    {
      name = "aws4-1.8.0.tgz";
      path = fetchurl {
        name = "aws4-1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/aws4/-/aws4-1.8.0.tgz";
        sha1 = "f0e003d9ca9e7f59c7a508945d7b2ef9a04a542f";
      };
    }

    {
      name = "babel-code-frame-6.26.0.tgz";
      path = fetchurl {
        name = "babel-code-frame-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-code-frame/-/babel-code-frame-6.26.0.tgz";
        sha1 = "63fd43f7dc1e3bb7ce35947db8fe369a3f58c74b";
      };
    }

    {
      name = "babel-core-6.26.3.tgz";
      path = fetchurl {
        name = "babel-core-6.26.3.tgz";
        url  = "https://registry.yarnpkg.com/babel-core/-/babel-core-6.26.3.tgz";
        sha1 = "b2e2f09e342d0f0c88e2f02e067794125e75c207";
      };
    }

    {
      name = "babel-generator-6.26.1.tgz";
      path = fetchurl {
        name = "babel-generator-6.26.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-generator/-/babel-generator-6.26.1.tgz";
        sha1 = "1844408d3b8f0d35a404ea7ac180f087a601bd90";
      };
    }

    {
      name = "babel-helper-builder-binary-assignment-operator-visitor-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-builder-binary-assignment-operator-visitor-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-builder-binary-assignment-operator-visitor/-/babel-helper-builder-binary-assignment-operator-visitor-6.24.1.tgz";
        sha1 = "cce4517ada356f4220bcae8a02c2b346f9a56664";
      };
    }

    {
      name = "babel-helper-call-delegate-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-call-delegate-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-call-delegate/-/babel-helper-call-delegate-6.24.1.tgz";
        sha1 = "ece6aacddc76e41c3461f88bfc575bd0daa2df8d";
      };
    }

    {
      name = "babel-helper-define-map-6.26.0.tgz";
      path = fetchurl {
        name = "babel-helper-define-map-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-define-map/-/babel-helper-define-map-6.26.0.tgz";
        sha1 = "a5f56dab41a25f97ecb498c7ebaca9819f95be5f";
      };
    }

    {
      name = "babel-helper-explode-assignable-expression-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-explode-assignable-expression-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-explode-assignable-expression/-/babel-helper-explode-assignable-expression-6.24.1.tgz";
        sha1 = "f25b82cf7dc10433c55f70592d5746400ac22caa";
      };
    }

    {
      name = "babel-helper-function-name-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-function-name-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-function-name/-/babel-helper-function-name-6.24.1.tgz";
        sha1 = "d3475b8c03ed98242a25b48351ab18399d3580a9";
      };
    }

    {
      name = "babel-helper-get-function-arity-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-get-function-arity-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-get-function-arity/-/babel-helper-get-function-arity-6.24.1.tgz";
        sha1 = "8f7782aa93407c41d3aa50908f89b031b1b6853d";
      };
    }

    {
      name = "babel-helper-hoist-variables-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-hoist-variables-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-hoist-variables/-/babel-helper-hoist-variables-6.24.1.tgz";
        sha1 = "1ecb27689c9d25513eadbc9914a73f5408be7a76";
      };
    }

    {
      name = "babel-helper-optimise-call-expression-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-optimise-call-expression-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-optimise-call-expression/-/babel-helper-optimise-call-expression-6.24.1.tgz";
        sha1 = "f7a13427ba9f73f8f4fa993c54a97882d1244257";
      };
    }

    {
      name = "babel-helper-regex-6.26.0.tgz";
      path = fetchurl {
        name = "babel-helper-regex-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-regex/-/babel-helper-regex-6.26.0.tgz";
        sha1 = "325c59f902f82f24b74faceed0363954f6495e72";
      };
    }

    {
      name = "babel-helper-remap-async-to-generator-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-remap-async-to-generator-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-remap-async-to-generator/-/babel-helper-remap-async-to-generator-6.24.1.tgz";
        sha1 = "5ec581827ad723fecdd381f1c928390676e4551b";
      };
    }

    {
      name = "babel-helper-replace-supers-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helper-replace-supers-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helper-replace-supers/-/babel-helper-replace-supers-6.24.1.tgz";
        sha1 = "bf6dbfe43938d17369a213ca8a8bf74b6a90ab1a";
      };
    }

    {
      name = "babel-helpers-6.24.1.tgz";
      path = fetchurl {
        name = "babel-helpers-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-helpers/-/babel-helpers-6.24.1.tgz";
        sha1 = "3471de9caec388e5c850e597e58a26ddf37602b2";
      };
    }

    {
      name = "babel-messages-6.23.0.tgz";
      path = fetchurl {
        name = "babel-messages-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-messages/-/babel-messages-6.23.0.tgz";
        sha1 = "f3cdf4703858035b2a2951c6ec5edf6c62f2630e";
      };
    }

    {
      name = "babel-plugin-check-es2015-constants-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-check-es2015-constants-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-check-es2015-constants/-/babel-plugin-check-es2015-constants-6.22.0.tgz";
        sha1 = "35157b101426fd2ffd3da3f75c7d1e91835bbf8a";
      };
    }

    {
      name = "babel-plugin-debug-macros-0.1.11.tgz";
      path = fetchurl {
        name = "babel-plugin-debug-macros-0.1.11.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-debug-macros/-/babel-plugin-debug-macros-0.1.11.tgz";
        sha1 = "6c562bf561fccd406ce14ab04f42c218cf956605";
      };
    }

    {
      name = "babel-plugin-debug-macros-0.2.0-beta.6.tgz";
      path = fetchurl {
        name = "babel-plugin-debug-macros-0.2.0-beta.6.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-debug-macros/-/babel-plugin-debug-macros-0.2.0-beta.6.tgz";
        sha1 = "ecdf6e408d5c863ab21740d7ad7f43f027d2f912";
      };
    }

    {
      name = "babel-plugin-ember-modules-api-polyfill-2.3.2.tgz";
      path = fetchurl {
        name = "babel-plugin-ember-modules-api-polyfill-2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-ember-modules-api-polyfill/-/babel-plugin-ember-modules-api-polyfill-2.3.2.tgz";
        sha1 = "56ea34bea963498d070a2b7dc2ce18a92c434093";
      };
    }

    {
      name = "babel-plugin-ember-modules-api-polyfill-2.4.0.tgz";
      path = fetchurl {
        name = "babel-plugin-ember-modules-api-polyfill-2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-ember-modules-api-polyfill/-/babel-plugin-ember-modules-api-polyfill-2.4.0.tgz";
        sha1 = "3db44fb214b56a1965f80b9f042ca1b6670559fb";
      };
    }

    {
      name = "babel-plugin-feature-flags-0.3.1.tgz";
      path = fetchurl {
        name = "babel-plugin-feature-flags-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-feature-flags/-/babel-plugin-feature-flags-0.3.1.tgz";
        sha1 = "9c827cf9a4eb9a19f725ccb239e85cab02036fc1";
      };
    }

    {
      name = "babel-plugin-filter-imports-0.3.1.tgz";
      path = fetchurl {
        name = "babel-plugin-filter-imports-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-filter-imports/-/babel-plugin-filter-imports-0.3.1.tgz";
        sha1 = "e7859b56886b175dd2616425d277b219e209ea8b";
      };
    }

    {
      name = "babel-plugin-htmlbars-inline-precompile-0.2.6.tgz";
      path = fetchurl {
        name = "babel-plugin-htmlbars-inline-precompile-0.2.6.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-htmlbars-inline-precompile/-/babel-plugin-htmlbars-inline-precompile-0.2.6.tgz";
        sha1 = "c00b8a3f4b32ca04bf0f0d5169fcef3b5a66d69d";
      };
    }

    {
      name = "babel-plugin-syntax-async-functions-6.13.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-async-functions-6.13.0.tgz";
        url  = "http://registry.npmjs.org/babel-plugin-syntax-async-functions/-/babel-plugin-syntax-async-functions-6.13.0.tgz";
        sha1 = "cad9cad1191b5ad634bf30ae0872391e0647be95";
      };
    }

    {
      name = "babel-plugin-syntax-dynamic-import-6.18.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-dynamic-import-6.18.0.tgz";
        url  = "http://registry.npmjs.org/babel-plugin-syntax-dynamic-import/-/babel-plugin-syntax-dynamic-import-6.18.0.tgz";
        sha1 = "8d6a26229c83745a9982a441051572caa179b1da";
      };
    }

    {
      name = "babel-plugin-syntax-exponentiation-operator-6.13.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-exponentiation-operator-6.13.0.tgz";
        url  = "http://registry.npmjs.org/babel-plugin-syntax-exponentiation-operator/-/babel-plugin-syntax-exponentiation-operator-6.13.0.tgz";
        sha1 = "9ee7e8337290da95288201a6a57f4170317830de";
      };
    }

    {
      name = "babel-plugin-syntax-object-rest-spread-6.13.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-object-rest-spread-6.13.0.tgz";
        url  = "http://registry.npmjs.org/babel-plugin-syntax-object-rest-spread/-/babel-plugin-syntax-object-rest-spread-6.13.0.tgz";
        sha1 = "fd6536f2bce13836ffa3a5458c4903a597bb3bf5";
      };
    }

    {
      name = "babel-plugin-syntax-trailing-function-commas-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-syntax-trailing-function-commas-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-syntax-trailing-function-commas/-/babel-plugin-syntax-trailing-function-commas-6.22.0.tgz";
        sha1 = "ba0360937f8d06e40180a43fe0d5616fff532cf3";
      };
    }

    {
      name = "babel-plugin-transform-async-to-generator-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-async-to-generator-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-async-to-generator/-/babel-plugin-transform-async-to-generator-6.24.1.tgz";
        sha1 = "6536e378aff6cb1d5517ac0e40eb3e9fc8d08761";
      };
    }

    {
      name = "babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-arrow-functions/-/babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz";
        sha1 = "452692cb711d5f79dc7f85e440ce41b9f244d221";
      };
    }

    {
      name = "babel-plugin-transform-es2015-block-scoped-functions-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-block-scoped-functions-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-block-scoped-functions/-/babel-plugin-transform-es2015-block-scoped-functions-6.22.0.tgz";
        sha1 = "bbc51b49f964d70cb8d8e0b94e820246ce3a6141";
      };
    }

    {
      name = "babel-plugin-transform-es2015-block-scoping-6.26.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-block-scoping-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-block-scoping/-/babel-plugin-transform-es2015-block-scoping-6.26.0.tgz";
        sha1 = "d70f5299c1308d05c12f463813b0a09e73b1895f";
      };
    }

    {
      name = "babel-plugin-transform-es2015-classes-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-classes-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-classes/-/babel-plugin-transform-es2015-classes-6.24.1.tgz";
        sha1 = "5a4c58a50c9c9461e564b4b2a3bfabc97a2584db";
      };
    }

    {
      name = "babel-plugin-transform-es2015-computed-properties-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-computed-properties-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-computed-properties/-/babel-plugin-transform-es2015-computed-properties-6.24.1.tgz";
        sha1 = "6fe2a8d16895d5634f4cd999b6d3480a308159b3";
      };
    }

    {
      name = "babel-plugin-transform-es2015-destructuring-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-destructuring-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-destructuring/-/babel-plugin-transform-es2015-destructuring-6.23.0.tgz";
        sha1 = "997bb1f1ab967f682d2b0876fe358d60e765c56d";
      };
    }

    {
      name = "babel-plugin-transform-es2015-duplicate-keys-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-duplicate-keys-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-duplicate-keys/-/babel-plugin-transform-es2015-duplicate-keys-6.24.1.tgz";
        sha1 = "73eb3d310ca969e3ef9ec91c53741a6f1576423e";
      };
    }

    {
      name = "babel-plugin-transform-es2015-for-of-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-for-of-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-for-of/-/babel-plugin-transform-es2015-for-of-6.23.0.tgz";
        sha1 = "f47c95b2b613df1d3ecc2fdb7573623c75248691";
      };
    }

    {
      name = "babel-plugin-transform-es2015-function-name-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-function-name-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-function-name/-/babel-plugin-transform-es2015-function-name-6.24.1.tgz";
        sha1 = "834c89853bc36b1af0f3a4c5dbaa94fd8eacaa8b";
      };
    }

    {
      name = "babel-plugin-transform-es2015-literals-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-literals-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-literals/-/babel-plugin-transform-es2015-literals-6.22.0.tgz";
        sha1 = "4f54a02d6cd66cf915280019a31d31925377ca2e";
      };
    }

    {
      name = "babel-plugin-transform-es2015-modules-amd-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-modules-amd-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-amd/-/babel-plugin-transform-es2015-modules-amd-6.24.1.tgz";
        sha1 = "3b3e54017239842d6d19c3011c4bd2f00a00d154";
      };
    }

    {
      name = "babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-commonjs/-/babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz";
        sha1 = "58a793863a9e7ca870bdc5a881117ffac27db6f3";
      };
    }

    {
      name = "babel-plugin-transform-es2015-modules-systemjs-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-modules-systemjs-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-systemjs/-/babel-plugin-transform-es2015-modules-systemjs-6.24.1.tgz";
        sha1 = "ff89a142b9119a906195f5f106ecf305d9407d23";
      };
    }

    {
      name = "babel-plugin-transform-es2015-modules-umd-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-modules-umd-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-umd/-/babel-plugin-transform-es2015-modules-umd-6.24.1.tgz";
        sha1 = "ac997e6285cd18ed6176adb607d602344ad38468";
      };
    }

    {
      name = "babel-plugin-transform-es2015-object-super-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-object-super-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-object-super/-/babel-plugin-transform-es2015-object-super-6.24.1.tgz";
        sha1 = "24cef69ae21cb83a7f8603dad021f572eb278f8d";
      };
    }

    {
      name = "babel-plugin-transform-es2015-parameters-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-parameters-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-parameters/-/babel-plugin-transform-es2015-parameters-6.24.1.tgz";
        sha1 = "57ac351ab49caf14a97cd13b09f66fdf0a625f2b";
      };
    }

    {
      name = "babel-plugin-transform-es2015-shorthand-properties-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-shorthand-properties-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-shorthand-properties/-/babel-plugin-transform-es2015-shorthand-properties-6.24.1.tgz";
        sha1 = "24f875d6721c87661bbd99a4622e51f14de38aa0";
      };
    }

    {
      name = "babel-plugin-transform-es2015-spread-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-spread-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-spread/-/babel-plugin-transform-es2015-spread-6.22.0.tgz";
        sha1 = "d6d68a99f89aedc4536c81a542e8dd9f1746f8d1";
      };
    }

    {
      name = "babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-sticky-regex/-/babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz";
        sha1 = "00c1cdb1aca71112cdf0cf6126c2ed6b457ccdbc";
      };
    }

    {
      name = "babel-plugin-transform-es2015-template-literals-6.22.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-template-literals-6.22.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-template-literals/-/babel-plugin-transform-es2015-template-literals-6.22.0.tgz";
        sha1 = "a84b3450f7e9f8f1f6839d6d687da84bb1236d8d";
      };
    }

    {
      name = "babel-plugin-transform-es2015-typeof-symbol-6.23.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-typeof-symbol-6.23.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-typeof-symbol/-/babel-plugin-transform-es2015-typeof-symbol-6.23.0.tgz";
        sha1 = "dec09f1cddff94b52ac73d505c84df59dcceb372";
      };
    }

    {
      name = "babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-es2015-unicode-regex/-/babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz";
        sha1 = "d38b12f42ea7323f729387f18a7c5ae1faeb35e9";
      };
    }

    {
      name = "babel-plugin-transform-exponentiation-operator-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-exponentiation-operator-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-exponentiation-operator/-/babel-plugin-transform-exponentiation-operator-6.24.1.tgz";
        sha1 = "2ab0c9c7f3098fa48907772bb813fe41e8de3a0e";
      };
    }

    {
      name = "babel-plugin-transform-object-rest-spread-6.26.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-object-rest-spread-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-object-rest-spread/-/babel-plugin-transform-object-rest-spread-6.26.0.tgz";
        sha1 = "0f36692d50fef6b7e2d4b3ac1478137a963b7b06";
      };
    }

    {
      name = "babel-plugin-transform-regenerator-6.26.0.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-regenerator-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-regenerator/-/babel-plugin-transform-regenerator-6.26.0.tgz";
        sha1 = "e0703696fbde27f0a3efcacf8b4dca2f7b3a8f2f";
      };
    }

    {
      name = "babel-plugin-transform-strict-mode-6.24.1.tgz";
      path = fetchurl {
        name = "babel-plugin-transform-strict-mode-6.24.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-transform-strict-mode/-/babel-plugin-transform-strict-mode-6.24.1.tgz";
        sha1 = "d5faf7aa578a65bbe591cf5edae04a0c67020758";
      };
    }

    {
      name = "babel-polyfill-6.26.0.tgz";
      path = fetchurl {
        name = "babel-polyfill-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-polyfill/-/babel-polyfill-6.26.0.tgz";
        sha1 = "379937abc67d7895970adc621f284cd966cf2153";
      };
    }

    {
      name = "babel-preset-env-1.7.0.tgz";
      path = fetchurl {
        name = "babel-preset-env-1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-preset-env/-/babel-preset-env-1.7.0.tgz";
        sha1 = "dea79fa4ebeb883cd35dab07e260c1c9c04df77a";
      };
    }

    {
      name = "babel-register-6.26.0.tgz";
      path = fetchurl {
        name = "babel-register-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-register/-/babel-register-6.26.0.tgz";
        sha1 = "6ed021173e2fcb486d7acb45c6009a856f647071";
      };
    }

    {
      name = "babel-runtime-6.26.0.tgz";
      path = fetchurl {
        name = "babel-runtime-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-runtime/-/babel-runtime-6.26.0.tgz";
        sha1 = "965c7058668e82b55d7bfe04ff2337bc8b5647fe";
      };
    }

    {
      name = "babel-template-6.26.0.tgz";
      path = fetchurl {
        name = "babel-template-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-template/-/babel-template-6.26.0.tgz";
        sha1 = "de03e2d16396b069f46dd9fff8521fb1a0e35e02";
      };
    }

    {
      name = "babel-traverse-6.26.0.tgz";
      path = fetchurl {
        name = "babel-traverse-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-traverse/-/babel-traverse-6.26.0.tgz";
        sha1 = "46a9cbd7edcc62c8e5c064e2d2d8d0f4035766ee";
      };
    }

    {
      name = "babel-types-6.26.0.tgz";
      path = fetchurl {
        name = "babel-types-6.26.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-types/-/babel-types-6.26.0.tgz";
        sha1 = "a3b073f94ab49eb6fa55cd65227a334380632497";
      };
    }

    {
      name = "babel6-plugin-strip-class-callcheck-6.0.0.tgz";
      path = fetchurl {
        name = "babel6-plugin-strip-class-callcheck-6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/babel6-plugin-strip-class-callcheck/-/babel6-plugin-strip-class-callcheck-6.0.0.tgz";
        sha1 = "de841c1abebbd39f78de0affb2c9a52ee228fddf";
      };
    }

    {
      name = "babel6-plugin-strip-heimdall-6.0.1.tgz";
      path = fetchurl {
        name = "babel6-plugin-strip-heimdall-6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/babel6-plugin-strip-heimdall/-/babel6-plugin-strip-heimdall-6.0.1.tgz";
        sha1 = "35f80eddec1f7fffdc009811dfbd46d9965072b6";
      };
    }

    {
      name = "babylon-6.18.0.tgz";
      path = fetchurl {
        name = "babylon-6.18.0.tgz";
        url  = "https://registry.yarnpkg.com/babylon/-/babylon-6.18.0.tgz";
        sha1 = "af2f3b88fa6f5c1e4c634d1a0f8eac4f55b395e3";
      };
    }

    {
      name = "backbone-1.3.3.tgz";
      path = fetchurl {
        name = "backbone-1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/backbone/-/backbone-1.3.3.tgz";
        sha1 = "4cc80ea7cb1631ac474889ce40f2f8bc683b2999";
      };
    }

    {
      name = "backo2-1.0.2.tgz";
      path = fetchurl {
        name = "backo2-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/backo2/-/backo2-1.0.2.tgz";
        sha1 = "31ab1ac8b129363463e35b3ebb69f4dfcfba7947";
      };
    }

    {
      name = "balanced-match-1.0.0.tgz";
      path = fetchurl {
        name = "balanced-match-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.0.tgz";
        sha1 = "89b4d199ab2bee49de164ea02b89ce462d71b767";
      };
    }

    {
      name = "base64-arraybuffer-0.1.5.tgz";
      path = fetchurl {
        name = "base64-arraybuffer-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/base64-arraybuffer/-/base64-arraybuffer-0.1.5.tgz";
        sha1 = "73926771923b5a19747ad666aa5cd4bf9c6e9ce8";
      };
    }

    {
      name = "base64-js-1.2.1.tgz";
      path = fetchurl {
        name = "base64-js-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/base64-js/-/base64-js-1.2.1.tgz";
        sha1 = "a91947da1f4a516ea38e5b4ec0ec3773675e0886";
      };
    }

    {
      name = "base64-js-1.3.0.tgz";
      path = fetchurl {
        name = "base64-js-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/base64-js/-/base64-js-1.3.0.tgz";
        sha1 = "cab1e6118f051095e58b5281aea8c1cd22bfc0e3";
      };
    }

    {
      name = "base64id-1.0.0.tgz";
      path = fetchurl {
        name = "base64id-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/base64id/-/base64id-1.0.0.tgz";
        sha1 = "47688cb99bb6804f0e06d3e763b1c32e57d8e6b6";
      };
    }

    {
      name = "base-0.11.2.tgz";
      path = fetchurl {
        name = "base-0.11.2.tgz";
        url  = "https://registry.yarnpkg.com/base/-/base-0.11.2.tgz";
        sha1 = "7bde5ced145b6d551a90db87f83c558b4eb48a8f";
      };
    }

    {
      name = "basic-auth-2.0.0.tgz";
      path = fetchurl {
        name = "basic-auth-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/basic-auth/-/basic-auth-2.0.0.tgz";
        sha1 = "015db3f353e02e56377755f962742e8981e7bbba";
      };
    }

    {
      name = "bcrypt-pbkdf-1.0.2.tgz";
      path = fetchurl {
        name = "bcrypt-pbkdf-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz";
        sha1 = "a4301d389b6a43f9b67ff3ca11a3f6637e360e9e";
      };
    }

    {
      name = "before-after-hook-1.1.0.tgz";
      path = fetchurl {
        name = "before-after-hook-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/before-after-hook/-/before-after-hook-1.1.0.tgz";
        sha1 = "83165e15a59460d13702cb8febd6a1807896db5a";
      };
    }

    {
      name = "better-assert-1.0.2.tgz";
      path = fetchurl {
        name = "better-assert-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/better-assert/-/better-assert-1.0.2.tgz";
        sha1 = "40866b9e1b9e0b55b481894311e68faffaebc522";
      };
    }

    {
      name = "big.js-3.2.0.tgz";
      path = fetchurl {
        name = "big.js-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/big.js/-/big.js-3.2.0.tgz";
        sha1 = "a5fc298b81b9e0dca2e458824784b65c52ba588e";
      };
    }

    {
      name = "bignumber.js-2.4.0.tgz";
      path = fetchurl {
        name = "bignumber.js-2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/bignumber.js/-/bignumber.js-2.4.0.tgz";
        sha1 = "838a992da9f9d737e0f4b2db0be62bb09dd0c5e8";
      };
    }

    {
      name = "bin-links-1.1.2.tgz";
      path = fetchurl {
        name = "bin-links-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/bin-links/-/bin-links-1.1.2.tgz";
        sha1 = "fb74bd54bae6b7befc6c6221f25322ac830d9757";
      };
    }

    {
      name = "binary-extensions-1.11.0.tgz";
      path = fetchurl {
        name = "binary-extensions-1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-1.11.0.tgz";
        sha1 = "46aa1751fb6a2f93ee5e689bb1087d4b14c6c205";
      };
    }

    {
      name = "binaryextensions-2.1.1.tgz";
      path = fetchurl {
        name = "binaryextensions-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/binaryextensions/-/binaryextensions-2.1.1.tgz";
        sha1 = "3209a51ca4a4ad541a3b8d3d6a6d5b83a2485935";
      };
    }

    {
      name = "blank-object-1.0.2.tgz";
      path = fetchurl {
        name = "blank-object-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/blank-object/-/blank-object-1.0.2.tgz";
        sha1 = "f990793fbe9a8c8dd013fb3219420bec81d5f4b9";
      };
    }

    {
      name = "blob-0.0.4.tgz";
      path = fetchurl {
        name = "blob-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/blob/-/blob-0.0.4.tgz";
        sha1 = "bcf13052ca54463f30f9fc7e95b9a47630a94921";
      };
    }

    {
      name = "block-stream-0.0.9.tgz";
      path = fetchurl {
        name = "block-stream-0.0.9.tgz";
        url  = "https://registry.yarnpkg.com/block-stream/-/block-stream-0.0.9.tgz";
        sha1 = "13ebfe778a03205cfe03751481ebb4b3300c126a";
      };
    }

    {
      name = "bluebird-3.5.2.tgz";
      path = fetchurl {
        name = "bluebird-3.5.2.tgz";
        url  = "https://registry.yarnpkg.com/bluebird/-/bluebird-3.5.2.tgz";
        sha1 = "1be0908e054a751754549c270489c1505d4ab15a";
      };
    }

    {
      name = "bmp-js-0.0.1.tgz";
      path = fetchurl {
        name = "bmp-js-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/bmp-js/-/bmp-js-0.0.1.tgz";
        sha1 = "5ad0147099d13a9f38aa7b99af1d6e78666ed37f";
      };
    }

    {
      name = "bmp-js-0.0.3.tgz";
      path = fetchurl {
        name = "bmp-js-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/bmp-js/-/bmp-js-0.0.3.tgz";
        sha1 = "64113e9c7cf1202b376ed607bf30626ebe57b18a";
      };
    }

    {
      name = "bn.js-4.11.8.tgz";
      path = fetchurl {
        name = "bn.js-4.11.8.tgz";
        url  = "https://registry.yarnpkg.com/bn.js/-/bn.js-4.11.8.tgz";
        sha1 = "2cde09eb5ee341f484746bb0309b3253b1b1442f";
      };
    }

    {
      name = "body-parser-1.18.2.tgz";
      path = fetchurl {
        name = "body-parser-1.18.2.tgz";
        url  = "https://registry.yarnpkg.com/body-parser/-/body-parser-1.18.2.tgz";
        sha1 = "87678a19d84b47d859b83199bd59bce222b10454";
      };
    }

    {
      name = "body-parser-1.18.3.tgz";
      path = fetchurl {
        name = "body-parser-1.18.3.tgz";
        url  = "https://registry.yarnpkg.com/body-parser/-/body-parser-1.18.3.tgz";
        sha1 = "5b292198ffdd553b3a0f20ded0592b956955c8b4";
      };
    }

    {
      name = "body-5.1.0.tgz";
      path = fetchurl {
        name = "body-5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/body/-/body-5.1.0.tgz";
        sha1 = "e4ba0ce410a46936323367609ecb4e6553125069";
      };
    }

    {
      name = "boolbase-1.0.0.tgz";
      path = fetchurl {
        name = "boolbase-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/boolbase/-/boolbase-1.0.0.tgz";
        sha1 = "68dff5fbe60c51eb37725ea9e3ed310dcc1e776e";
      };
    }

    {
      name = "boolify-1.0.1.tgz";
      path = fetchurl {
        name = "boolify-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/boolify/-/boolify-1.0.1.tgz";
        sha1 = "b5c09e17cacd113d11b7bb3ed384cc012994d86b";
      };
    }

    {
      name = "bottleneck-2.9.0.tgz";
      path = fetchurl {
        name = "bottleneck-2.9.0.tgz";
        url  = "https://registry.yarnpkg.com/bottleneck/-/bottleneck-2.9.0.tgz";
        sha1 = "1cf11c3c9db1b65075fae03967418ea03ba66814";
      };
    }

    {
      name = "bower-config-1.4.1.tgz";
      path = fetchurl {
        name = "bower-config-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/bower-config/-/bower-config-1.4.1.tgz";
        sha1 = "85fd9df367c2b8dbbd0caa4c5f2bad40cd84c2cc";
      };
    }

    {
      name = "bower-endpoint-parser-0.2.2.tgz";
      path = fetchurl {
        name = "bower-endpoint-parser-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/bower-endpoint-parser/-/bower-endpoint-parser-0.2.2.tgz";
        sha1 = "00b565adbfab6f2d35addde977e97962acbcb3f6";
      };
    }

    {
      name = "boxen-1.3.0.tgz";
      path = fetchurl {
        name = "boxen-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/boxen/-/boxen-1.3.0.tgz";
        sha1 = "55c6c39a8ba58d9c61ad22cd877532deb665a20b";
      };
    }

    {
      name = "brace-expansion-1.1.11.tgz";
      path = fetchurl {
        name = "brace-expansion-1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz";
        sha1 = "3c7fcbf529d87226f3d2f52b966ff5271eb441dd";
      };
    }

    {
      name = "braces-1.8.5.tgz";
      path = fetchurl {
        name = "braces-1.8.5.tgz";
        url  = "https://registry.yarnpkg.com/braces/-/braces-1.8.5.tgz";
        sha1 = "ba77962e12dff969d6b76711e914b737857bf6a7";
      };
    }

    {
      name = "braces-2.3.2.tgz";
      path = fetchurl {
        name = "braces-2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/braces/-/braces-2.3.2.tgz";
        sha1 = "5979fd3f14cd531565e5fa2df1abfff1dfaee729";
      };
    }

    {
      name = "broccoli-amd-funnel-1.3.0.tgz";
      path = fetchurl {
        name = "broccoli-amd-funnel-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-amd-funnel/-/broccoli-amd-funnel-1.3.0.tgz";
        sha1 = "c4426b4fce976e44295bd74f34725f53bdeb08e3";
      };
    }

    {
      name = "broccoli-asset-rev-2.7.0.tgz";
      path = fetchurl {
        name = "broccoli-asset-rev-2.7.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-asset-rev/-/broccoli-asset-rev-2.7.0.tgz";
        sha1 = "c73da1d97c4180366fa442a87624ca1b7fb99161";
      };
    }

    {
      name = "broccoli-asset-rewrite-1.1.0.tgz";
      path = fetchurl {
        name = "broccoli-asset-rewrite-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-asset-rewrite/-/broccoli-asset-rewrite-1.1.0.tgz";
        sha1 = "77a5da56157aa318c59113245e8bafb4617f8830";
      };
    }

    {
      name = "broccoli-autoprefixer-5.0.0.tgz";
      path = fetchurl {
        name = "broccoli-autoprefixer-5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-autoprefixer/-/broccoli-autoprefixer-5.0.0.tgz";
        sha1 = "68c9f3bfdfff9df2d39e46545b9cf9d4443d6a16";
      };
    }

    {
      name = "broccoli-babel-transpiler-6.5.0.tgz";
      path = fetchurl {
        name = "broccoli-babel-transpiler-6.5.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-babel-transpiler/-/broccoli-babel-transpiler-6.5.0.tgz";
        sha1 = "aa501a227b298a99742fdd0309b1eaad7124bba0";
      };
    }

    {
      name = "broccoli-builder-0.18.14.tgz";
      path = fetchurl {
        name = "broccoli-builder-0.18.14.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-builder/-/broccoli-builder-0.18.14.tgz";
        sha1 = "4b79e2f844de11a4e1b816c3f49c6df4776c312d";
      };
    }

    {
      name = "broccoli-caching-writer-2.3.1.tgz";
      path = fetchurl {
        name = "broccoli-caching-writer-2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-caching-writer/-/broccoli-caching-writer-2.3.1.tgz";
        sha1 = "b93cf58f9264f003075868db05774f4e7f25bd07";
      };
    }

    {
      name = "broccoli-caching-writer-3.0.3.tgz";
      path = fetchurl {
        name = "broccoli-caching-writer-3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-caching-writer/-/broccoli-caching-writer-3.0.3.tgz";
        sha1 = "0bd2c96a9738d6a6ab590f07ba35c5157d7db476";
      };
    }

    {
      name = "broccoli-clean-css-1.1.0.tgz";
      path = fetchurl {
        name = "broccoli-clean-css-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-clean-css/-/broccoli-clean-css-1.1.0.tgz";
        sha1 = "9db143d9af7e0ae79c26e3ac5a9bb2d720ea19fa";
      };
    }

    {
      name = "broccoli-concat-3.7.1.tgz";
      path = fetchurl {
        name = "broccoli-concat-3.7.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-concat/-/broccoli-concat-3.7.1.tgz";
        sha1 = "22ba97420b33f5254549adc5bc41163f97bd1793";
      };
    }

    {
      name = "broccoli-config-loader-1.0.1.tgz";
      path = fetchurl {
        name = "broccoli-config-loader-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-config-loader/-/broccoli-config-loader-1.0.1.tgz";
        sha1 = "d10aaf8ebc0cb45c1da5baa82720e1d88d28c80a";
      };
    }

    {
      name = "broccoli-config-replace-1.1.2.tgz";
      path = fetchurl {
        name = "broccoli-config-replace-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-config-replace/-/broccoli-config-replace-1.1.2.tgz";
        sha1 = "6ea879d92a5bad634d11329b51fc5f4aafda9c00";
      };
    }

    {
      name = "broccoli-debug-0.6.4.tgz";
      path = fetchurl {
        name = "broccoli-debug-0.6.4.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-debug/-/broccoli-debug-0.6.4.tgz";
        sha1 = "986eb3d2005e00e3bb91f9d0a10ab137210cd150";
      };
    }

    {
      name = "broccoli-favicon-1.0.0.tgz";
      path = fetchurl {
        name = "broccoli-favicon-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-favicon/-/broccoli-favicon-1.0.0.tgz";
        sha1 = "c770a5aa16032fbaf1b5c9c033f71b9cc5a5cb51";
      };
    }

    {
      name = "broccoli-file-creator-1.2.0.tgz";
      path = fetchurl {
        name = "broccoli-file-creator-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-file-creator/-/broccoli-file-creator-1.2.0.tgz";
        sha1 = "27f1b25b1b00e7bb7bf3d5d7abed5f4d5388df4d";
      };
    }

    {
      name = "broccoli-file-creator-2.1.1.tgz";
      path = fetchurl {
        name = "broccoli-file-creator-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-file-creator/-/broccoli-file-creator-2.1.1.tgz";
        sha1 = "7351dd2496c762cfce7736ce9b49e3fce0c7b7db";
      };
    }

    {
      name = "broccoli-filter-0.1.14.tgz";
      path = fetchurl {
        name = "broccoli-filter-0.1.14.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-filter/-/broccoli-filter-0.1.14.tgz";
        sha1 = "23cae3891ff9ebb7b4d7db00c6dcf03535daf7ad";
      };
    }

    {
      name = "broccoli-filter-1.3.0.tgz";
      path = fetchurl {
        name = "broccoli-filter-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-filter/-/broccoli-filter-1.3.0.tgz";
        sha1 = "71e3a8e32a17f309e12261919c5b1006d6766de6";
      };
    }

    {
      name = "broccoli-funnel-reducer-1.0.0.tgz";
      path = fetchurl {
        name = "broccoli-funnel-reducer-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-funnel-reducer/-/broccoli-funnel-reducer-1.0.0.tgz";
        sha1 = "11365b2a785aec9b17972a36df87eef24c5cc0ea";
      };
    }

    {
      name = "broccoli-funnel-1.2.0.tgz";
      path = fetchurl {
        name = "broccoli-funnel-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-funnel/-/broccoli-funnel-1.2.0.tgz";
        sha1 = "cddc3afc5ff1685a8023488fff74ce6fb5a51296";
      };
    }

    {
      name = "broccoli-funnel-2.0.1.tgz";
      path = fetchurl {
        name = "broccoli-funnel-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-funnel/-/broccoli-funnel-2.0.1.tgz";
        sha1 = "6823c73b675ef78fffa7ab800f083e768b51d449";
      };
    }

    {
      name = "broccoli-kitchen-sink-helpers-0.2.9.tgz";
      path = fetchurl {
        name = "broccoli-kitchen-sink-helpers-0.2.9.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-kitchen-sink-helpers/-/broccoli-kitchen-sink-helpers-0.2.9.tgz";
        sha1 = "a5e0986ed8d76fb5984b68c3f0450d3a96e36ecc";
      };
    }

    {
      name = "broccoli-kitchen-sink-helpers-0.3.1.tgz";
      path = fetchurl {
        name = "broccoli-kitchen-sink-helpers-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-kitchen-sink-helpers/-/broccoli-kitchen-sink-helpers-0.3.1.tgz";
        sha1 = "77c7c18194b9664163ec4fcee2793444926e0c06";
      };
    }

    {
      name = "broccoli-lint-eslint-4.2.1.tgz";
      path = fetchurl {
        name = "broccoli-lint-eslint-4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-lint-eslint/-/broccoli-lint-eslint-4.2.1.tgz";
        sha1 = "f780dc083a7357a9746a9cfa8f76feb092777477";
      };
    }

    {
      name = "broccoli-merge-trees-1.2.4.tgz";
      path = fetchurl {
        name = "broccoli-merge-trees-1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-merge-trees/-/broccoli-merge-trees-1.2.4.tgz";
        sha1 = "a001519bb5067f06589d91afa2942445a2d0fdb5";
      };
    }

    {
      name = "broccoli-merge-trees-2.0.1.tgz";
      path = fetchurl {
        name = "broccoli-merge-trees-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-merge-trees/-/broccoli-merge-trees-2.0.1.tgz";
        sha1 = "14d4b7fc1a90318c12b16f843e6ba2693808100c";
      };
    }

    {
      name = "broccoli-merge-trees-3.0.1.tgz";
      path = fetchurl {
        name = "broccoli-merge-trees-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-merge-trees/-/broccoli-merge-trees-3.0.1.tgz";
        sha1 = "545dfe9f695cec43372b3ee7e63c7203713ea554";
      };
    }

    {
      name = "broccoli-middleware-2.0.1.tgz";
      path = fetchurl {
        name = "broccoli-middleware-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-middleware/-/broccoli-middleware-2.0.1.tgz";
        sha1 = "093314f13e52fad7fa8c4254a4e4a4560c857a65";
      };
    }

    {
      name = "broccoli-module-normalizer-1.3.0.tgz";
      path = fetchurl {
        name = "broccoli-module-normalizer-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-module-normalizer/-/broccoli-module-normalizer-1.3.0.tgz";
        sha1 = "f9982d9cbb776b4ed754161cc6547784d3eb19de";
      };
    }

    {
      name = "broccoli-module-unification-reexporter-1.0.0.tgz";
      path = fetchurl {
        name = "broccoli-module-unification-reexporter-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-module-unification-reexporter/-/broccoli-module-unification-reexporter-1.0.0.tgz";
        sha1 = "031909c5d3f159ec11d5f9e2346f2861db8acb3e";
      };
    }

    {
      name = "broccoli-node-info-1.1.0.tgz";
      path = fetchurl {
        name = "broccoli-node-info-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-node-info/-/broccoli-node-info-1.1.0.tgz";
        sha1 = "3aa2e31e07e5bdb516dd25214f7c45ba1c459412";
      };
    }

    {
      name = "broccoli-persistent-filter-1.4.3.tgz";
      path = fetchurl {
        name = "broccoli-persistent-filter-1.4.3.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-persistent-filter/-/broccoli-persistent-filter-1.4.3.tgz";
        sha1 = "3511bc52fc53740cda51621f58a28152d9911bc1";
      };
    }

    {
      name = "broccoli-plugin-1.1.0.tgz";
      path = fetchurl {
        name = "broccoli-plugin-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-plugin/-/broccoli-plugin-1.1.0.tgz";
        sha1 = "73e2cfa05f8ea1e3fc1420c40c3d9e7dc724bf02";
      };
    }

    {
      name = "broccoli-plugin-1.3.1.tgz";
      path = fetchurl {
        name = "broccoli-plugin-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-plugin/-/broccoli-plugin-1.3.1.tgz";
        sha1 = "a26315732fb99ed2d9fb58f12a1e14e986b4fabd";
      };
    }

    {
      name = "broccoli-replace-0.12.0.tgz";
      path = fetchurl {
        name = "broccoli-replace-0.12.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-replace/-/broccoli-replace-0.12.0.tgz";
        sha1 = "36460a984c45c61731638c53068b0ab12ea8fdb7";
      };
    }

    {
      name = "broccoli-rollup-2.1.1.tgz";
      path = fetchurl {
        name = "broccoli-rollup-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-rollup/-/broccoli-rollup-2.1.1.tgz";
        sha1 = "0b77dc4b7560a53e998ea85f3b56772612d4988d";
      };
    }

    {
      name = "broccoli-sass-source-maps-2.2.0.tgz";
      path = fetchurl {
        name = "broccoli-sass-source-maps-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-sass-source-maps/-/broccoli-sass-source-maps-2.2.0.tgz";
        sha1 = "1f1a0794136152b096188638b59b42b17a4bdc68";
      };
    }

    {
      name = "broccoli-slow-trees-3.0.1.tgz";
      path = fetchurl {
        name = "broccoli-slow-trees-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-slow-trees/-/broccoli-slow-trees-3.0.1.tgz";
        sha1 = "9bf2a9e2f8eb3ed3a3f2abdde988da437ccdc9b4";
      };
    }

    {
      name = "broccoli-source-1.1.0.tgz";
      path = fetchurl {
        name = "broccoli-source-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-source/-/broccoli-source-1.1.0.tgz";
        sha1 = "54f0e82c8b73f46580cbbc4f578f0b32fca8f809";
      };
    }

    {
      name = "5ebad6f345c38d45461676c7a298a0b61be4a39d";
      path = fetchurl {
        name = "5ebad6f345c38d45461676c7a298a0b61be4a39d";
        url  = "https://codeload.github.com/meirish/broccoli-sri-hash/tar.gz/5ebad6f345c38d45461676c7a298a0b61be4a39d";
        sha1 = "2a5818cb88b7b6ed5bfdddcba6a3747fe6f096c6";
      };
    }

    {
      name = "broccoli-stew-1.6.0.tgz";
      path = fetchurl {
        name = "broccoli-stew-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-stew/-/broccoli-stew-1.6.0.tgz";
        sha1 = "01f6d92806ed6679ddbe48d405066a0e164dfbef";
      };
    }

    {
      name = "broccoli-stew-2.0.0.tgz";
      path = fetchurl {
        name = "broccoli-stew-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-stew/-/broccoli-stew-2.0.0.tgz";
        sha1 = "68f3d94f13b4a79aa15d582703574fb4c3215e50";
      };
    }

    {
      name = "broccoli-string-replace-0.1.2.tgz";
      path = fetchurl {
        name = "broccoli-string-replace-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-string-replace/-/broccoli-string-replace-0.1.2.tgz";
        sha1 = "1ed92f85680af8d503023925e754e4e33676b91f";
      };
    }

    {
      name = "broccoli-templater-1.0.0.tgz";
      path = fetchurl {
        name = "broccoli-templater-1.0.0.tgz";
        url  = "http://registry.npmjs.org/broccoli-templater/-/broccoli-templater-1.0.0.tgz";
        sha1 = "7c054aacf596d1868d1a44291f9ec7b907d30ecf";
      };
    }

    {
      name = "broccoli-uglify-sourcemap-2.2.0.tgz";
      path = fetchurl {
        name = "broccoli-uglify-sourcemap-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-uglify-sourcemap/-/broccoli-uglify-sourcemap-2.2.0.tgz";
        sha1 = "2ff49389bdf342a550c3596750ba2dde95a8f7d4";
      };
    }

    {
      name = "broccoli-unwatched-tree-0.1.3.tgz";
      path = fetchurl {
        name = "broccoli-unwatched-tree-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-unwatched-tree/-/broccoli-unwatched-tree-0.1.3.tgz";
        sha1 = "ab0fb820f613845bf67a803baad820f68b1e3aae";
      };
    }

    {
      name = "broccoli-writer-0.1.1.tgz";
      path = fetchurl {
        name = "broccoli-writer-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/broccoli-writer/-/broccoli-writer-0.1.1.tgz";
        sha1 = "d4d71aa8f2afbc67a3866b91a2da79084b96ab2d";
      };
    }

    {
      name = "brorand-1.1.0.tgz";
      path = fetchurl {
        name = "brorand-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/brorand/-/brorand-1.1.0.tgz";
        sha1 = "12c25efe40a45e3c323eb8675a0a0ce57b22371f";
      };
    }

    {
      name = "browser-process-hrtime-0.1.2.tgz";
      path = fetchurl {
        name = "browser-process-hrtime-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/browser-process-hrtime/-/browser-process-hrtime-0.1.2.tgz";
        sha1 = "425d68a58d3447f02a04aa894187fce8af8b7b8e";
      };
    }

    {
      name = "browserify-aes-1.2.0.tgz";
      path = fetchurl {
        name = "browserify-aes-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/browserify-aes/-/browserify-aes-1.2.0.tgz";
        sha1 = "326734642f403dabc3003209853bb70ad428ef48";
      };
    }

    {
      name = "browserify-cipher-1.0.1.tgz";
      path = fetchurl {
        name = "browserify-cipher-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/browserify-cipher/-/browserify-cipher-1.0.1.tgz";
        sha1 = "8d6474c1b870bfdabcd3bcfcc1934a10e94f15f0";
      };
    }

    {
      name = "browserify-des-1.0.2.tgz";
      path = fetchurl {
        name = "browserify-des-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/browserify-des/-/browserify-des-1.0.2.tgz";
        sha1 = "3af4f1f59839403572f1c66204375f7a7f703e9c";
      };
    }

    {
      name = "browserify-rsa-4.0.1.tgz";
      path = fetchurl {
        name = "browserify-rsa-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/browserify-rsa/-/browserify-rsa-4.0.1.tgz";
        sha1 = "21e0abfaf6f2029cf2fafb133567a701d4135524";
      };
    }

    {
      name = "browserify-sign-4.0.4.tgz";
      path = fetchurl {
        name = "browserify-sign-4.0.4.tgz";
        url  = "https://registry.yarnpkg.com/browserify-sign/-/browserify-sign-4.0.4.tgz";
        sha1 = "aa4eb68e5d7b658baa6bf6a57e630cbd7a93d298";
      };
    }

    {
      name = "browserify-zlib-0.2.0.tgz";
      path = fetchurl {
        name = "browserify-zlib-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/browserify-zlib/-/browserify-zlib-0.2.0.tgz";
        sha1 = "2869459d9aa3be245fe8fe2ca1f46e2e7f54d73f";
      };
    }

    {
      name = "browserslist-2.11.3.tgz";
      path = fetchurl {
        name = "browserslist-2.11.3.tgz";
        url  = "https://registry.yarnpkg.com/browserslist/-/browserslist-2.11.3.tgz";
        sha1 = "fe36167aed1bbcde4827ebfe71347a2cc70b99b2";
      };
    }

    {
      name = "browserslist-3.2.8.tgz";
      path = fetchurl {
        name = "browserslist-3.2.8.tgz";
        url  = "https://registry.yarnpkg.com/browserslist/-/browserslist-3.2.8.tgz";
        sha1 = "b0005361d6471f0f5952797a76fc985f1f978fc6";
      };
    }

    {
      name = "bser-2.0.0.tgz";
      path = fetchurl {
        name = "bser-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/bser/-/bser-2.0.0.tgz";
        sha1 = "9ac78d3ed5d915804fd87acb158bc797147a1719";
      };
    }

    {
      name = "btoa-lite-1.0.0.tgz";
      path = fetchurl {
        name = "btoa-lite-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/btoa-lite/-/btoa-lite-1.0.0.tgz";
        sha1 = "337766da15801210fdd956c22e9c6891ab9d0337";
      };
    }

    {
      name = "buffer-alloc-unsafe-1.1.0.tgz";
      path = fetchurl {
        name = "buffer-alloc-unsafe-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz";
        sha1 = "bd7dc26ae2972d0eda253be061dba992349c19f0";
      };
    }

    {
      name = "buffer-alloc-1.2.0.tgz";
      path = fetchurl {
        name = "buffer-alloc-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-alloc/-/buffer-alloc-1.2.0.tgz";
        sha1 = "890dd90d923a873e08e10e5fd51a57e5b7cce0ec";
      };
    }

    {
      name = "buffer-equal-0.0.1.tgz";
      path = fetchurl {
        name = "buffer-equal-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-0.0.1.tgz";
        sha1 = "91bc74b11ea405bc916bc6aa908faafa5b4aac4b";
      };
    }

    {
      name = "buffer-fill-1.0.0.tgz";
      path = fetchurl {
        name = "buffer-fill-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-fill/-/buffer-fill-1.0.0.tgz";
        sha1 = "f8f78b76789888ef39f205cd637f68e702122b2c";
      };
    }

    {
      name = "buffer-from-1.1.1.tgz";
      path = fetchurl {
        name = "buffer-from-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.1.tgz";
        sha1 = "32713bc028f75c02fdb710d7c7bcec1f2c6070ef";
      };
    }

    {
      name = "buffer-xor-1.0.3.tgz";
      path = fetchurl {
        name = "buffer-xor-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/buffer-xor/-/buffer-xor-1.0.3.tgz";
        sha1 = "26e61ed1422fb70dd42e6e36729ed51d855fe8d9";
      };
    }

    {
      name = "buffer-4.9.1.tgz";
      path = fetchurl {
        name = "buffer-4.9.1.tgz";
        url  = "http://registry.npmjs.org/buffer/-/buffer-4.9.1.tgz";
        sha1 = "6d1bb601b07a4efced97094132093027c95bc298";
      };
    }

    {
      name = "build-0.1.4.tgz";
      path = fetchurl {
        name = "build-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/build/-/build-0.1.4.tgz";
        sha1 = "707fe026ffceddcacbfdcdf356eafda64f151046";
      };
    }

    {
      name = "builtin-modules-1.1.1.tgz";
      path = fetchurl {
        name = "builtin-modules-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/builtin-modules/-/builtin-modules-1.1.1.tgz";
        sha1 = "270f076c5a72c02f5b65a47df94c5fe3a278892f";
      };
    }

    {
      name = "builtin-status-codes-3.0.0.tgz";
      path = fetchurl {
        name = "builtin-status-codes-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/builtin-status-codes/-/builtin-status-codes-3.0.0.tgz";
        sha1 = "85982878e21b98e1c66425e03d0174788f569ee8";
      };
    }

    {
      name = "builtins-1.0.3.tgz";
      path = fetchurl {
        name = "builtins-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/builtins/-/builtins-1.0.3.tgz";
        sha1 = "cb94faeb61c8696451db36534e1422f94f0aee88";
      };
    }

    {
      name = "bulma-switch-0.0.1.tgz";
      path = fetchurl {
        name = "bulma-switch-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/bulma-switch/-/bulma-switch-0.0.1.tgz";
        sha1 = "2de6eb7c602244de7c5efa880b3b19b8464012a9";
      };
    }

    {
      name = "bulma-0.5.3.tgz";
      path = fetchurl {
        name = "bulma-0.5.3.tgz";
        url  = "https://registry.yarnpkg.com/bulma/-/bulma-0.5.3.tgz";
        sha1 = "be93afb6246192505c30df3f9c1c29a97d319a13";
      };
    }

    {
      name = "byline-5.0.0.tgz";
      path = fetchurl {
        name = "byline-5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/byline/-/byline-5.0.0.tgz";
        sha1 = "741c5216468eadc457b03410118ad77de8c1ddb1";
      };
    }

    {
      name = "byte-size-4.0.3.tgz";
      path = fetchurl {
        name = "byte-size-4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/byte-size/-/byte-size-4.0.3.tgz";
        sha1 = "b7c095efc68eadf82985fccd9a2df43a74fa2ccd";
      };
    }

    {
      name = "bytes-1.0.0.tgz";
      path = fetchurl {
        name = "bytes-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/bytes/-/bytes-1.0.0.tgz";
        sha1 = "3569ede8ba34315fab99c3e92cb04c7220de1fa8";
      };
    }

    {
      name = "bytes-3.0.0.tgz";
      path = fetchurl {
        name = "bytes-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/bytes/-/bytes-3.0.0.tgz";
        sha1 = "d32815404d689699f85a4ea4fa8755dd13a96048";
      };
    }

    {
      name = "cacache-10.0.4.tgz";
      path = fetchurl {
        name = "cacache-10.0.4.tgz";
        url  = "https://registry.yarnpkg.com/cacache/-/cacache-10.0.4.tgz";
        sha1 = "6452367999eff9d4188aefd9a14e9d7c6a263460";
      };
    }

    {
      name = "cacache-11.2.0.tgz";
      path = fetchurl {
        name = "cacache-11.2.0.tgz";
        url  = "https://registry.yarnpkg.com/cacache/-/cacache-11.2.0.tgz";
        sha1 = "617bdc0b02844af56310e411c0878941d5739965";
      };
    }

    {
      name = "cache-base-1.0.1.tgz";
      path = fetchurl {
        name = "cache-base-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/cache-base/-/cache-base-1.0.1.tgz";
        sha1 = "0a7f46416831c8b662ee36fe4e7c59d76f666ab2";
      };
    }

    {
      name = "calculate-cache-key-for-tree-1.1.0.tgz";
      path = fetchurl {
        name = "calculate-cache-key-for-tree-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/calculate-cache-key-for-tree/-/calculate-cache-key-for-tree-1.1.0.tgz";
        sha1 = "0c3e42c9c134f3c9de5358c0f16793627ea976d6";
      };
    }

    {
      name = "call-limit-1.1.0.tgz";
      path = fetchurl {
        name = "call-limit-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/call-limit/-/call-limit-1.1.0.tgz";
        sha1 = "6fd61b03f3da42a2cd0ec2b60f02bd0e71991fea";
      };
    }

    {
      name = "call-me-maybe-1.0.1.tgz";
      path = fetchurl {
        name = "call-me-maybe-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/call-me-maybe/-/call-me-maybe-1.0.1.tgz";
        sha1 = "26d208ea89e37b5cbde60250a15f031c16a4d66b";
      };
    }

    {
      name = "caller-path-0.1.0.tgz";
      path = fetchurl {
        name = "caller-path-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/caller-path/-/caller-path-0.1.0.tgz";
        sha1 = "94085ef63581ecd3daa92444a8fe94e82577751f";
      };
    }

    {
      name = "callsite-1.0.0.tgz";
      path = fetchurl {
        name = "callsite-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/callsite/-/callsite-1.0.0.tgz";
        sha1 = "280398e5d664bd74038b6f0905153e6e8af1bc20";
      };
    }

    {
      name = "callsites-0.2.0.tgz";
      path = fetchurl {
        name = "callsites-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/callsites/-/callsites-0.2.0.tgz";
        sha1 = "afab96262910a7f33c19a5775825c69f34e350ca";
      };
    }

    {
      name = "camelcase-keys-2.1.0.tgz";
      path = fetchurl {
        name = "camelcase-keys-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/camelcase-keys/-/camelcase-keys-2.1.0.tgz";
        sha1 = "308beeaffdf28119051efa1d932213c91b8f92e7";
      };
    }

    {
      name = "camelcase-keys-4.2.0.tgz";
      path = fetchurl {
        name = "camelcase-keys-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/camelcase-keys/-/camelcase-keys-4.2.0.tgz";
        sha1 = "a2aa5fb1af688758259c32c141426d78923b9b77";
      };
    }

    {
      name = "camelcase-2.1.1.tgz";
      path = fetchurl {
        name = "camelcase-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-2.1.1.tgz";
        sha1 = "7c1d16d679a1bbe59ca02cacecfb011e201f5a1f";
      };
    }

    {
      name = "camelcase-3.0.0.tgz";
      path = fetchurl {
        name = "camelcase-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-3.0.0.tgz";
        sha1 = "32fc4b9fcdaf845fcdf7e73bb97cac2261f0ab0a";
      };
    }

    {
      name = "camelcase-4.1.0.tgz";
      path = fetchurl {
        name = "camelcase-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-4.1.0.tgz";
        sha1 = "d545635be1e33c542649c69173e5de6acfae34dd";
      };
    }

    {
      name = "can-symlink-1.0.0.tgz";
      path = fetchurl {
        name = "can-symlink-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/can-symlink/-/can-symlink-1.0.0.tgz";
        sha1 = "97b607d8a84bb6c6e228b902d864ecb594b9d219";
      };
    }

    {
      name = "caniuse-lite-1.0.30000885.tgz";
      path = fetchurl {
        name = "caniuse-lite-1.0.30000885.tgz";
        url  = "https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30000885.tgz";
        sha1 = "e889e9f8e7e50e769f2a49634c932b8aee622984";
      };
    }

    {
      name = "capture-exit-1.2.0.tgz";
      path = fetchurl {
        name = "capture-exit-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/capture-exit/-/capture-exit-1.2.0.tgz";
        sha1 = "1c5fcc489fd0ab00d4f1ac7ae1072e3173fbab6f";
      };
    }

    {
      name = "capture-stack-trace-1.0.1.tgz";
      path = fetchurl {
        name = "capture-stack-trace-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/capture-stack-trace/-/capture-stack-trace-1.0.1.tgz";
        sha1 = "a6c0bbe1f38f3aa0b92238ecb6ff42c344d4135d";
      };
    }

    {
      name = "cardinal-1.0.0.tgz";
      path = fetchurl {
        name = "cardinal-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/cardinal/-/cardinal-1.0.0.tgz";
        sha1 = "50e21c1b0aa37729f9377def196b5a9cec932ee9";
      };
    }

    {
      name = "cardinal-2.1.1.tgz";
      path = fetchurl {
        name = "cardinal-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/cardinal/-/cardinal-2.1.1.tgz";
        sha1 = "7cc1055d822d212954d07b085dea251cc7bc5505";
      };
    }

    {
      name = "caseless-0.12.0.tgz";
      path = fetchurl {
        name = "caseless-0.12.0.tgz";
        url  = "https://registry.yarnpkg.com/caseless/-/caseless-0.12.0.tgz";
        sha1 = "1b681c21ff84033c826543090689420d187151dc";
      };
    }

    {
      name = "ceibo-2.0.0.tgz";
      path = fetchurl {
        name = "ceibo-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ceibo/-/ceibo-2.0.0.tgz";
        sha1 = "9a61eb054a91c09934588d4e45d9dd2c3bf04eee";
      };
    }

    {
      name = "chai-1.7.2.tgz";
      path = fetchurl {
        name = "chai-1.7.2.tgz";
        url  = "https://registry.yarnpkg.com/chai/-/chai-1.7.2.tgz";
        sha1 = "ba07ebd4e1ac138a296cdf69077ce74b7f4a1317";
      };
    }

    {
      name = "chalk-2.3.0.tgz";
      path = fetchurl {
        name = "chalk-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-2.3.0.tgz";
        sha1 = "b5ea48efc9c1793dccc9b4767c93914d3f2d52ba";
      };
    }

    {
      name = "chalk-1.1.3.tgz";
      path = fetchurl {
        name = "chalk-1.1.3.tgz";
        url  = "http://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz";
        sha1 = "a8115c55e4a702fe4d150abd3872822a7e09fc98";
      };
    }

    {
      name = "chalk-2.4.1.tgz";
      path = fetchurl {
        name = "chalk-2.4.1.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-2.4.1.tgz";
        sha1 = "18c49ab16a037b6eb0152cc83e3471338215b66e";
      };
    }

    {
      name = "chalk-0.4.0.tgz";
      path = fetchurl {
        name = "chalk-0.4.0.tgz";
        url  = "http://registry.npmjs.org/chalk/-/chalk-0.4.0.tgz";
        sha1 = "5199a3ddcd0c1efe23bc08c1b027b06176e0c64f";
      };
    }

    {
      name = "chardet-0.4.2.tgz";
      path = fetchurl {
        name = "chardet-0.4.2.tgz";
        url  = "https://registry.yarnpkg.com/chardet/-/chardet-0.4.2.tgz";
        sha1 = "b5473b33dc97c424e5d98dc87d55d4d8a29c8bf2";
      };
    }

    {
      name = "charm-1.0.2.tgz";
      path = fetchurl {
        name = "charm-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/charm/-/charm-1.0.2.tgz";
        sha1 = "8add367153a6d9a581331052c4090991da995e35";
      };
    }

    {
      name = "cheerio-0.19.0.tgz";
      path = fetchurl {
        name = "cheerio-0.19.0.tgz";
        url  = "https://registry.yarnpkg.com/cheerio/-/cheerio-0.19.0.tgz";
        sha1 = "772e7015f2ee29965096d71ea4175b75ab354925";
      };
    }

    {
      name = "chokidar-2.0.4.tgz";
      path = fetchurl {
        name = "chokidar-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/chokidar/-/chokidar-2.0.4.tgz";
        sha1 = "356ff4e2b0e8e43e322d18a372460bbcf3accd26";
      };
    }

    {
      name = "chownr-1.0.1.tgz";
      path = fetchurl {
        name = "chownr-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/chownr/-/chownr-1.0.1.tgz";
        sha1 = "e2a75042a9551908bebd25b8523d5f9769d79181";
      };
    }

    {
      name = "chrome-trace-event-1.0.0.tgz";
      path = fetchurl {
        name = "chrome-trace-event-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/chrome-trace-event/-/chrome-trace-event-1.0.0.tgz";
        sha1 = "45a91bd2c20c9411f0963b5aaeb9a1b95e09cc48";
      };
    }

    {
      name = "ci-info-1.5.1.tgz";
      path = fetchurl {
        name = "ci-info-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/ci-info/-/ci-info-1.5.1.tgz";
        sha1 = "17e8eb5de6f8b2b6038f0cbb714d410bfa9f3030";
      };
    }

    {
      name = "ci-info-1.5.0.tgz";
      path = fetchurl {
        name = "ci-info-1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/ci-info/-/ci-info-1.5.0.tgz";
        sha1 = "38327c69e98dab18487744b84e5d6e841a09a1a7";
      };
    }

    {
      name = "cidr-regex-2.0.9.tgz";
      path = fetchurl {
        name = "cidr-regex-2.0.9.tgz";
        url  = "https://registry.yarnpkg.com/cidr-regex/-/cidr-regex-2.0.9.tgz";
        sha1 = "9c17bb2b18e15af07f7d0c3b994b961d687ed1c9";
      };
    }

    {
      name = "cipher-base-1.0.4.tgz";
      path = fetchurl {
        name = "cipher-base-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/cipher-base/-/cipher-base-1.0.4.tgz";
        sha1 = "8760e4ecc272f4c363532f926d874aae2c1397de";
      };
    }

    {
      name = "circular-json-0.3.3.tgz";
      path = fetchurl {
        name = "circular-json-0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/circular-json/-/circular-json-0.3.3.tgz";
        sha1 = "815c99ea84f6809529d2f45791bdf82711352d66";
      };
    }

    {
      name = "class-utils-0.3.6.tgz";
      path = fetchurl {
        name = "class-utils-0.3.6.tgz";
        url  = "https://registry.yarnpkg.com/class-utils/-/class-utils-0.3.6.tgz";
        sha1 = "f93369ae8b9a7ce02fd41faad0ca83033190c463";
      };
    }

    {
      name = "clean-base-url-1.0.0.tgz";
      path = fetchurl {
        name = "clean-base-url-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/clean-base-url/-/clean-base-url-1.0.0.tgz";
        sha1 = "c901cf0a20b972435b0eccd52d056824a4351b7b";
      };
    }

    {
      name = "clean-css-promise-0.1.1.tgz";
      path = fetchurl {
        name = "clean-css-promise-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/clean-css-promise/-/clean-css-promise-0.1.1.tgz";
        sha1 = "43f3d2c8dfcb2bf071481252cd9b76433c08eecb";
      };
    }

    {
      name = "clean-css-3.4.28.tgz";
      path = fetchurl {
        name = "clean-css-3.4.28.tgz";
        url  = "https://registry.yarnpkg.com/clean-css/-/clean-css-3.4.28.tgz";
        sha1 = "bf1945e82fc808f55695e6ddeaec01400efd03ff";
      };
    }

    {
      name = "clean-stack-1.3.0.tgz";
      path = fetchurl {
        name = "clean-stack-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/clean-stack/-/clean-stack-1.3.0.tgz";
        sha1 = "9e821501ae979986c46b1d66d2d432db2fd4ae31";
      };
    }

    {
      name = "clean-up-path-1.0.0.tgz";
      path = fetchurl {
        name = "clean-up-path-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/clean-up-path/-/clean-up-path-1.0.0.tgz";
        sha1 = "de9e8196519912e749c9eaf67c13d64fac72a3e5";
      };
    }

    {
      name = "cli-boxes-1.0.0.tgz";
      path = fetchurl {
        name = "cli-boxes-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/cli-boxes/-/cli-boxes-1.0.0.tgz";
        sha1 = "4fa917c3e59c94a004cd61f8ee509da651687143";
      };
    }

    {
      name = "cli-columns-3.1.2.tgz";
      path = fetchurl {
        name = "cli-columns-3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/cli-columns/-/cli-columns-3.1.2.tgz";
        sha1 = "6732d972979efc2ae444a1f08e08fa139c96a18e";
      };
    }

    {
      name = "cli-cursor-1.0.2.tgz";
      path = fetchurl {
        name = "cli-cursor-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-1.0.2.tgz";
        sha1 = "64da3f7d56a54412e59794bd62dc35295e8f2987";
      };
    }

    {
      name = "cli-cursor-2.1.0.tgz";
      path = fetchurl {
        name = "cli-cursor-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-2.1.0.tgz";
        sha1 = "b35dac376479facc3e94747d41d0d0f5238ffcb5";
      };
    }

    {
      name = "cli-spinners-1.3.1.tgz";
      path = fetchurl {
        name = "cli-spinners-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/cli-spinners/-/cli-spinners-1.3.1.tgz";
        sha1 = "002c1990912d0d59580c93bd36c056de99e4259a";
      };
    }

    {
      name = "cli-table3-0.5.1.tgz";
      path = fetchurl {
        name = "cli-table3-0.5.1.tgz";
        url  = "https://registry.yarnpkg.com/cli-table3/-/cli-table3-0.5.1.tgz";
        sha1 = "0252372d94dfc40dbd8df06005f48f31f656f202";
      };
    }

    {
      name = "cli-table-0.3.1.tgz";
      path = fetchurl {
        name = "cli-table-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/cli-table/-/cli-table-0.3.1.tgz";
        sha1 = "f53b05266a8b1a0b934b3d0821e6e2dc5914ae23";
      };
    }

    {
      name = "cli-width-2.2.0.tgz";
      path = fetchurl {
        name = "cli-width-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/cli-width/-/cli-width-2.2.0.tgz";
        sha1 = "ff19ede8a9a5e579324147b0c11f0fbcbabed639";
      };
    }

    {
      name = "clipboard-1.7.1.tgz";
      path = fetchurl {
        name = "clipboard-1.7.1.tgz";
        url  = "https://registry.yarnpkg.com/clipboard/-/clipboard-1.7.1.tgz";
        sha1 = "360d6d6946e99a7a1fef395e42ba92b5e9b5a16b";
      };
    }

    {
      name = "cliui-3.2.0.tgz";
      path = fetchurl {
        name = "cliui-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/cliui/-/cliui-3.2.0.tgz";
        sha1 = "120601537a916d29940f934da3b48d585a39213d";
      };
    }

    {
      name = "cliui-4.1.0.tgz";
      path = fetchurl {
        name = "cliui-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cliui/-/cliui-4.1.0.tgz";
        sha1 = "348422dbe82d800b3022eef4f6ac10bf2e4d1b49";
      };
    }

    {
      name = "clone-stats-0.0.1.tgz";
      path = fetchurl {
        name = "clone-stats-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/clone-stats/-/clone-stats-0.0.1.tgz";
        sha1 = "b88f94a82cf38b8791d58046ea4029ad88ca99d1";
      };
    }

    {
      name = "clone-1.0.4.tgz";
      path = fetchurl {
        name = "clone-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/clone/-/clone-1.0.4.tgz";
        sha1 = "da309cc263df15994c688ca902179ca3c7cd7c7e";
      };
    }

    {
      name = "clone-2.1.2.tgz";
      path = fetchurl {
        name = "clone-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/clone/-/clone-2.1.2.tgz";
        sha1 = "1b7f4b9f591f1e8f83670401600345a02887435f";
      };
    }

    {
      name = "cmd-shim-2.0.2.tgz";
      path = fetchurl {
        name = "cmd-shim-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/cmd-shim/-/cmd-shim-2.0.2.tgz";
        sha1 = "6fcbda99483a8fd15d7d30a196ca69d688a2efdb";
      };
    }

    {
      name = "co-4.6.0.tgz";
      path = fetchurl {
        name = "co-4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/co/-/co-4.6.0.tgz";
        sha1 = "6ea6bdf3d853ae54ccb8e47bfa0bf3f9031fb184";
      };
    }

    {
      name = "code-point-at-1.1.0.tgz";
      path = fetchurl {
        name = "code-point-at-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz";
        sha1 = "0d070b4d043a5bea33a2f1a40e2edb3d9a4ccf77";
      };
    }

    {
      name = "codemirror-5.15.2.tgz";
      path = fetchurl {
        name = "codemirror-5.15.2.tgz";
        url  = "https://registry.yarnpkg.com/codemirror/-/codemirror-5.15.2.tgz";
        sha1 = "58b3dc732c6d10d7aae806f4c7cdd56a9b87fe8f";
      };
    }

    {
      name = "coffee-script-1.12.7.tgz";
      path = fetchurl {
        name = "coffee-script-1.12.7.tgz";
        url  = "https://registry.yarnpkg.com/coffee-script/-/coffee-script-1.12.7.tgz";
        sha1 = "c05dae0cb79591d05b3070a8433a98c9a89ccc53";
      };
    }

    {
      name = "collection-visit-1.0.0.tgz";
      path = fetchurl {
        name = "collection-visit-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/collection-visit/-/collection-visit-1.0.0.tgz";
        sha1 = "4bc0373c164bc3291b4d368c829cf1a80a59dca0";
      };
    }

    {
      name = "color-convert-1.9.3.tgz";
      path = fetchurl {
        name = "color-convert-1.9.3.tgz";
        url  = "https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz";
        sha1 = "bb71850690e1f136567de629d2d5471deda4c1e8";
      };
    }

    {
      name = "color-name-1.1.3.tgz";
      path = fetchurl {
        name = "color-name-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz";
        sha1 = "a7d0558bd89c42f795dd42328f740831ca53bc25";
      };
    }

    {
      name = "color-string-1.5.3.tgz";
      path = fetchurl {
        name = "color-string-1.5.3.tgz";
        url  = "https://registry.yarnpkg.com/color-string/-/color-string-1.5.3.tgz";
        sha1 = "c9bbc5f01b58b5492f3d6857459cb6590ce204cc";
      };
    }

    {
      name = "color-3.0.0.tgz";
      path = fetchurl {
        name = "color-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/color/-/color-3.0.0.tgz";
        sha1 = "d920b4328d534a3ac8295d68f7bd4ba6c427be9a";
      };
    }

    {
      name = "colornames-1.1.1.tgz";
      path = fetchurl {
        name = "colornames-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/colornames/-/colornames-1.1.1.tgz";
        sha1 = "f8889030685c7c4ff9e2a559f5077eb76a816f96";
      };
    }

    {
      name = "colors-1.0.3.tgz";
      path = fetchurl {
        name = "colors-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/colors/-/colors-1.0.3.tgz";
        sha1 = "0433f44d809680fdeb60ed260f1b0c262e82a40b";
      };
    }

    {
      name = "colors-1.3.2.tgz";
      path = fetchurl {
        name = "colors-1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/colors/-/colors-1.3.2.tgz";
        sha1 = "2df8ff573dfbf255af562f8ce7181d6b971a359b";
      };
    }

    {
      name = "colorspace-1.1.1.tgz";
      path = fetchurl {
        name = "colorspace-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/colorspace/-/colorspace-1.1.1.tgz";
        sha1 = "9ac2491e1bc6f8fb690e2176814f8d091636d972";
      };
    }

    {
      name = "columnify-1.5.4.tgz";
      path = fetchurl {
        name = "columnify-1.5.4.tgz";
        url  = "https://registry.yarnpkg.com/columnify/-/columnify-1.5.4.tgz";
        sha1 = "4737ddf1c7b69a8a7c340570782e947eec8e78bb";
      };
    }

    {
      name = "combined-stream-1.0.6.tgz";
      path = fetchurl {
        name = "combined-stream-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.6.tgz";
        sha1 = "723e7df6e801ac5613113a7e445a9b69cb632818";
      };
    }

    {
      name = "commander-0.6.1.tgz";
      path = fetchurl {
        name = "commander-0.6.1.tgz";
        url  = "http://registry.npmjs.org/commander/-/commander-0.6.1.tgz";
        sha1 = "fa68a14f6a945d54dbbe50d8cdb3320e9e3b1a06";
      };
    }

    {
      name = "commander-2.12.2.tgz";
      path = fetchurl {
        name = "commander-2.12.2.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.12.2.tgz";
        sha1 = "0f5946c427ed9ec0d91a46bb9def53e54650e555";
      };
    }

    {
      name = "commander-2.8.1.tgz";
      path = fetchurl {
        name = "commander-2.8.1.tgz";
        url  = "http://registry.npmjs.org/commander/-/commander-2.8.1.tgz";
        sha1 = "06be367febfda0c330aa1e2a072d3dc9762425d4";
      };
    }

    {
      name = "commander-2.18.0.tgz";
      path = fetchurl {
        name = "commander-2.18.0.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.18.0.tgz";
        sha1 = "2bf063ddee7c7891176981a2cc798e5754bc6970";
      };
    }

    {
      name = "commander-2.13.0.tgz";
      path = fetchurl {
        name = "commander-2.13.0.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.13.0.tgz";
        sha1 = "6964bca67685df7c1f1430c584f07d7597885b9c";
      };
    }

    {
      name = "commander-2.17.1.tgz";
      path = fetchurl {
        name = "commander-2.17.1.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.17.1.tgz";
        sha1 = "bd77ab7de6de94205ceacc72f1716d29f20a77bf";
      };
    }

    {
      name = "common-tags-1.8.0.tgz";
      path = fetchurl {
        name = "common-tags-1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/common-tags/-/common-tags-1.8.0.tgz";
        sha1 = "8e3153e542d4a39e9b10554434afaaf98956a937";
      };
    }

    {
      name = "commondir-1.0.1.tgz";
      path = fetchurl {
        name = "commondir-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz";
        sha1 = "ddd800da0c66127393cca5950ea968a3aaf1253b";
      };
    }

    {
      name = "compare-func-1.3.2.tgz";
      path = fetchurl {
        name = "compare-func-1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/compare-func/-/compare-func-1.3.2.tgz";
        sha1 = "99dd0ba457e1f9bc722b12c08ec33eeab31fa648";
      };
    }

    {
      name = "component-bind-1.0.0.tgz";
      path = fetchurl {
        name = "component-bind-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/component-bind/-/component-bind-1.0.0.tgz";
        sha1 = "00c608ab7dcd93897c0009651b1d3a8e1e73bbd1";
      };
    }

    {
      name = "component-emitter-1.2.1.tgz";
      path = fetchurl {
        name = "component-emitter-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.2.1.tgz";
        sha1 = "137918d6d78283f7df7a6b7c5a63e140e69425e6";
      };
    }

    {
      name = "component-inherit-0.0.3.tgz";
      path = fetchurl {
        name = "component-inherit-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/component-inherit/-/component-inherit-0.0.3.tgz";
        sha1 = "645fc4adf58b72b649d5cae65135619db26ff143";
      };
    }

    {
      name = "compressible-2.0.14.tgz";
      path = fetchurl {
        name = "compressible-2.0.14.tgz";
        url  = "https://registry.yarnpkg.com/compressible/-/compressible-2.0.14.tgz";
        sha1 = "326c5f507fbb055f54116782b969a81b67a29da7";
      };
    }

    {
      name = "compression-1.7.3.tgz";
      path = fetchurl {
        name = "compression-1.7.3.tgz";
        url  = "https://registry.yarnpkg.com/compression/-/compression-1.7.3.tgz";
        sha1 = "27e0e176aaf260f7f2c2813c3e440adb9f1993db";
      };
    }

    {
      name = "concat-map-0.0.1.tgz";
      path = fetchurl {
        name = "concat-map-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      };
    }

    {
      name = "concat-stream-1.6.2.tgz";
      path = fetchurl {
        name = "concat-stream-1.6.2.tgz";
        url  = "https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz";
        sha1 = "904bdf194cd3122fc675c77fc4ac3d4ff0fd1a34";
      };
    }

    {
      name = "config-chain-1.1.11.tgz";
      path = fetchurl {
        name = "config-chain-1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/config-chain/-/config-chain-1.1.11.tgz";
        sha1 = "aba09747dfbe4c3e70e766a6e41586e1859fc6f2";
      };
    }

    {
      name = "configstore-3.1.2.tgz";
      path = fetchurl {
        name = "configstore-3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/configstore/-/configstore-3.1.2.tgz";
        sha1 = "c6f25defaeef26df12dd33414b001fe81a543f8f";
      };
    }

    {
      name = "configstore-4.0.0.tgz";
      path = fetchurl {
        name = "configstore-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/configstore/-/configstore-4.0.0.tgz";
        sha1 = "5933311e95d3687efb592c528b922d9262d227e7";
      };
    }

    {
      name = "console-browserify-1.1.0.tgz";
      path = fetchurl {
        name = "console-browserify-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/console-browserify/-/console-browserify-1.1.0.tgz";
        sha1 = "f0241c45730a9fc6323b206dbf38edc741d0bb10";
      };
    }

    {
      name = "console-control-strings-1.1.0.tgz";
      path = fetchurl {
        name = "console-control-strings-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/console-control-strings/-/console-control-strings-1.1.0.tgz";
        sha1 = "3d7cf4464db6446ea644bf4b39507f9851008e8e";
      };
    }

    {
      name = "console-ui-2.2.2.tgz";
      path = fetchurl {
        name = "console-ui-2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/console-ui/-/console-ui-2.2.2.tgz";
        sha1 = "b294a2934de869dd06789ab4be69555411edef29";
      };
    }

    {
      name = "consolidate-0.15.1.tgz";
      path = fetchurl {
        name = "consolidate-0.15.1.tgz";
        url  = "https://registry.yarnpkg.com/consolidate/-/consolidate-0.15.1.tgz";
        sha1 = "21ab043235c71a07d45d9aad98593b0dba56bab7";
      };
    }

    {
      name = "constants-browserify-1.0.0.tgz";
      path = fetchurl {
        name = "constants-browserify-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/constants-browserify/-/constants-browserify-1.0.0.tgz";
        sha1 = "c20b96d8c617748aaf1c16021760cd27fcb8cb75";
      };
    }

    {
      name = "content-disposition-0.5.2.tgz";
      path = fetchurl {
        name = "content-disposition-0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/content-disposition/-/content-disposition-0.5.2.tgz";
        sha1 = "0cf68bb9ddf5f2be7961c3a85178cb85dba78cb4";
      };
    }

    {
      name = "content-type-1.0.4.tgz";
      path = fetchurl {
        name = "content-type-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/content-type/-/content-type-1.0.4.tgz";
        sha1 = "e138cc75e040c727b1966fe5e5f8c9aee256fe3b";
      };
    }

    {
      name = "continuable-cache-0.3.1.tgz";
      path = fetchurl {
        name = "continuable-cache-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/continuable-cache/-/continuable-cache-0.3.1.tgz";
        sha1 = "bd727a7faed77e71ff3985ac93351a912733ad0f";
      };
    }

    {
      name = "conventional-changelog-angular-5.0.1.tgz";
      path = fetchurl {
        name = "conventional-changelog-angular-5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/conventional-changelog-angular/-/conventional-changelog-angular-5.0.1.tgz";
        sha1 = "f96431b76de453333a909decd02b15cb5bd2d364";
      };
    }

    {
      name = "conventional-changelog-writer-4.0.0.tgz";
      path = fetchurl {
        name = "conventional-changelog-writer-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/conventional-changelog-writer/-/conventional-changelog-writer-4.0.0.tgz";
        sha1 = "3ed983c8ef6a3aa51fe44e82c9c75e86f1b5aa42";
      };
    }

    {
      name = "conventional-commits-filter-2.0.0.tgz";
      path = fetchurl {
        name = "conventional-commits-filter-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/conventional-commits-filter/-/conventional-commits-filter-2.0.0.tgz";
        sha1 = "a0ce1d1ff7a1dd7fab36bee8e8256d348d135651";
      };
    }

    {
      name = "conventional-commits-parser-3.0.0.tgz";
      path = fetchurl {
        name = "conventional-commits-parser-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/conventional-commits-parser/-/conventional-commits-parser-3.0.0.tgz";
        sha1 = "7f604549a50bd8f60443fbe515484b1c2f06a5c4";
      };
    }

    {
      name = "convert-source-map-1.6.0.tgz";
      path = fetchurl {
        name = "convert-source-map-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.6.0.tgz";
        sha1 = "51b537a8c43e0f04dec1993bffcdd504e758ac20";
      };
    }

    {
      name = "cookie-signature-1.0.6.tgz";
      path = fetchurl {
        name = "cookie-signature-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/cookie-signature/-/cookie-signature-1.0.6.tgz";
        sha1 = "e303a882b342cc3ee8ca513a79999734dab3ae2c";
      };
    }

    {
      name = "cookie-0.3.1.tgz";
      path = fetchurl {
        name = "cookie-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/cookie/-/cookie-0.3.1.tgz";
        sha1 = "e7e0a1f9ef43b4c8ba925c5c5a96e806d16873bb";
      };
    }

    {
      name = "cool-checkboxes-for-bulma.io-1.1.0.tgz";
      path = fetchurl {
        name = "cool-checkboxes-for-bulma.io-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cool-checkboxes-for-bulma.io/-/cool-checkboxes-for-bulma.io-1.1.0.tgz";
        sha1 = "4715f5144b952b9c9d19eab5315d738359fae833";
      };
    }

    {
      name = "copy-concurrently-1.0.5.tgz";
      path = fetchurl {
        name = "copy-concurrently-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/copy-concurrently/-/copy-concurrently-1.0.5.tgz";
        sha1 = "92297398cae34937fcafd6ec8139c18051f0b5e0";
      };
    }

    {
      name = "copy-dereference-1.0.0.tgz";
      path = fetchurl {
        name = "copy-dereference-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/copy-dereference/-/copy-dereference-1.0.0.tgz";
        sha1 = "6b131865420fd81b413ba994b44d3655311152b6";
      };
    }

    {
      name = "copy-descriptor-0.1.1.tgz";
      path = fetchurl {
        name = "copy-descriptor-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/copy-descriptor/-/copy-descriptor-0.1.1.tgz";
        sha1 = "676f6eb3c39997c2ee1ac3a924fd6124748f578d";
      };
    }

    {
      name = "core-js-2.5.7.tgz";
      path = fetchurl {
        name = "core-js-2.5.7.tgz";
        url  = "https://registry.yarnpkg.com/core-js/-/core-js-2.5.7.tgz";
        sha1 = "f972608ff0cead68b841a16a932d0b183791814e";
      };
    }

    {
      name = "core-object-3.1.5.tgz";
      path = fetchurl {
        name = "core-object-3.1.5.tgz";
        url  = "https://registry.yarnpkg.com/core-object/-/core-object-3.1.5.tgz";
        sha1 = "fa627b87502adc98045e44678e9a8ec3b9c0d2a9";
      };
    }

    {
      name = "core-util-is-1.0.2.tgz";
      path = fetchurl {
        name = "core-util-is-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz";
        sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
      };
    }

    {
      name = "cosmiconfig-5.0.6.tgz";
      path = fetchurl {
        name = "cosmiconfig-5.0.6.tgz";
        url  = "https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-5.0.6.tgz";
        sha1 = "dca6cf680a0bd03589aff684700858c81abeeb39";
      };
    }

    {
      name = "create-ecdh-4.0.3.tgz";
      path = fetchurl {
        name = "create-ecdh-4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/create-ecdh/-/create-ecdh-4.0.3.tgz";
        sha1 = "c9111b6f33045c4697f144787f9254cdc77c45ff";
      };
    }

    {
      name = "create-error-class-3.0.2.tgz";
      path = fetchurl {
        name = "create-error-class-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/create-error-class/-/create-error-class-3.0.2.tgz";
        sha1 = "06be7abef947a3f14a30fd610671d401bca8b7b6";
      };
    }

    {
      name = "create-hash-1.2.0.tgz";
      path = fetchurl {
        name = "create-hash-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/create-hash/-/create-hash-1.2.0.tgz";
        sha1 = "889078af11a63756bcfb59bd221996be3a9ef196";
      };
    }

    {
      name = "create-hmac-1.1.7.tgz";
      path = fetchurl {
        name = "create-hmac-1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/create-hmac/-/create-hmac-1.1.7.tgz";
        sha1 = "69170c78b3ab957147b2b8b04572e47ead2243ff";
      };
    }

    {
      name = "cross-spawn-3.0.1.tgz";
      path = fetchurl {
        name = "cross-spawn-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-3.0.1.tgz";
        sha1 = "1256037ecb9f0c5f79e3d6ef135e30770184b982";
      };
    }

    {
      name = "cross-spawn-5.1.0.tgz";
      path = fetchurl {
        name = "cross-spawn-5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-5.1.0.tgz";
        sha1 = "e8bd0efee58fcff6f8f94510a0a554bbfa235449";
      };
    }

    {
      name = "cross-spawn-6.0.5.tgz";
      path = fetchurl {
        name = "cross-spawn-6.0.5.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-6.0.5.tgz";
        sha1 = "4a5ec7c64dfae22c3a14124dbacdee846d80cbc4";
      };
    }

    {
      name = "crypto-browserify-3.12.0.tgz";
      path = fetchurl {
        name = "crypto-browserify-3.12.0.tgz";
        url  = "https://registry.yarnpkg.com/crypto-browserify/-/crypto-browserify-3.12.0.tgz";
        sha1 = "396cf9f3137f03e4b8e532c58f698254e00f80ec";
      };
    }

    {
      name = "crypto-random-string-1.0.0.tgz";
      path = fetchurl {
        name = "crypto-random-string-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/crypto-random-string/-/crypto-random-string-1.0.0.tgz";
        sha1 = "a230f64f568310e1498009940790ec99545bca7e";
      };
    }

    {
      name = "cson-parser-1.3.5.tgz";
      path = fetchurl {
        name = "cson-parser-1.3.5.tgz";
        url  = "https://registry.yarnpkg.com/cson-parser/-/cson-parser-1.3.5.tgz";
        sha1 = "7ec675e039145533bf2a6a856073f1599d9c2d24";
      };
    }

    {
      name = "css-select-1.0.0.tgz";
      path = fetchurl {
        name = "css-select-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/css-select/-/css-select-1.0.0.tgz";
        sha1 = "b1121ca51848dd264e2244d058cee254deeb44b0";
      };
    }

    {
      name = "css-what-1.0.0.tgz";
      path = fetchurl {
        name = "css-what-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/css-what/-/css-what-1.0.0.tgz";
        sha1 = "d7cc2df45180666f99d2b14462639469e00f736c";
      };
    }

    {
      name = "cssmin-0.3.2.tgz";
      path = fetchurl {
        name = "cssmin-0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/cssmin/-/cssmin-0.3.2.tgz";
        sha1 = "ddce4c547b510ae0d594a8f1fbf8aaf8e2c5c00d";
      };
    }

    {
      name = "cssom-0.3.4.tgz";
      path = fetchurl {
        name = "cssom-0.3.4.tgz";
        url  = "https://registry.yarnpkg.com/cssom/-/cssom-0.3.4.tgz";
        sha1 = "8cd52e8a3acfd68d3aed38ee0a640177d2f9d797";
      };
    }

    {
      name = "cssstyle-1.1.1.tgz";
      path = fetchurl {
        name = "cssstyle-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/cssstyle/-/cssstyle-1.1.1.tgz";
        sha1 = "18b038a9c44d65f7a8e428a653b9f6fe42faf5fb";
      };
    }

    {
      name = "currently-unhandled-0.4.1.tgz";
      path = fetchurl {
        name = "currently-unhandled-0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/currently-unhandled/-/currently-unhandled-0.4.1.tgz";
        sha1 = "988df33feab191ef799a61369dd76c17adf957ea";
      };
    }

    {
      name = "cyclist-0.2.2.tgz";
      path = fetchurl {
        name = "cyclist-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/cyclist/-/cyclist-0.2.2.tgz";
        sha1 = "1b33792e11e914a2fd6d6ed6447464444e5fa640";
      };
    }

    {
      name = "dag-map-2.0.2.tgz";
      path = fetchurl {
        name = "dag-map-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/dag-map/-/dag-map-2.0.2.tgz";
        sha1 = "9714b472de82a1843de2fba9b6876938cab44c68";
      };
    }

    {
      name = "dashdash-1.14.1.tgz";
      path = fetchurl {
        name = "dashdash-1.14.1.tgz";
        url  = "https://registry.yarnpkg.com/dashdash/-/dashdash-1.14.1.tgz";
        sha1 = "853cfa0f7cbe2fed5de20326b8dd581035f6e2f0";
      };
    }

    {
      name = "data-urls-1.0.1.tgz";
      path = fetchurl {
        name = "data-urls-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/data-urls/-/data-urls-1.0.1.tgz";
        sha1 = "d416ac3896918f29ca84d81085bc3705834da579";
      };
    }

    {
      name = "date-now-0.1.4.tgz";
      path = fetchurl {
        name = "date-now-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/date-now/-/date-now-0.1.4.tgz";
        sha1 = "eaf439fd4d4848ad74e5cc7dbef200672b9e345b";
      };
    }

    {
      name = "date-time-2.1.0.tgz";
      path = fetchurl {
        name = "date-time-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/date-time/-/date-time-2.1.0.tgz";
        sha1 = "0286d1b4c769633b3ca13e1e62558d2dbdc2eba2";
      };
    }

    {
      name = "dateformat-3.0.3.tgz";
      path = fetchurl {
        name = "dateformat-3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/dateformat/-/dateformat-3.0.3.tgz";
        sha1 = "a6e37499a4d9a9cf85ef5872044d62901c9889ae";
      };
    }

    {
      name = "debug-3.1.0.tgz";
      path = fetchurl {
        name = "debug-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-3.1.0.tgz";
        sha1 = "5bb5a0672628b64149566ba16819e61518c67261";
      };
    }

    {
      name = "debug-2.6.9.tgz";
      path = fetchurl {
        name = "debug-2.6.9.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz";
        sha1 = "5d128515df134ff327e90a4c93f4e077a536341f";
      };
    }

    {
      name = "debug-2.2.0.tgz";
      path = fetchurl {
        name = "debug-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.2.0.tgz";
        sha1 = "f87057e995b1a1f6ae6a4960664137bc56f039da";
      };
    }

    {
      name = "debuglog-1.0.1.tgz";
      path = fetchurl {
        name = "debuglog-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/debuglog/-/debuglog-1.0.1.tgz";
        sha1 = "aa24ffb9ac3df9a2351837cfb2d279360cd78492";
      };
    }

    {
      name = "decamelize-keys-1.1.0.tgz";
      path = fetchurl {
        name = "decamelize-keys-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/decamelize-keys/-/decamelize-keys-1.1.0.tgz";
        sha1 = "d171a87933252807eb3cb61dc1c1445d078df2d9";
      };
    }

    {
      name = "decamelize-1.2.0.tgz";
      path = fetchurl {
        name = "decamelize-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz";
        sha1 = "f6534d15148269b20352e7bee26f501f9a191290";
      };
    }

    {
      name = "decamelize-2.0.0.tgz";
      path = fetchurl {
        name = "decamelize-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/decamelize/-/decamelize-2.0.0.tgz";
        sha1 = "656d7bbc8094c4c788ea53c5840908c9c7d063c7";
      };
    }

    {
      name = "decode-uri-component-0.2.0.tgz";
      path = fetchurl {
        name = "decode-uri-component-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/decode-uri-component/-/decode-uri-component-0.2.0.tgz";
        sha1 = "eb3913333458775cb84cd1a1fae062106bb87545";
      };
    }

    {
      name = "deep-extend-0.6.0.tgz";
      path = fetchurl {
        name = "deep-extend-0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz";
        sha1 = "c4fa7c95404a17a9c3e8ca7e1537312b736330ac";
      };
    }

    {
      name = "deep-is-0.1.3.tgz";
      path = fetchurl {
        name = "deep-is-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.3.tgz";
        sha1 = "b369d6fb5dbc13eecf524f91b070feedc357cf34";
      };
    }

    {
      name = "deepmerge-2.1.1.tgz";
      path = fetchurl {
        name = "deepmerge-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/deepmerge/-/deepmerge-2.1.1.tgz";
        sha1 = "e862b4e45ea0555072bf51e7fd0d9845170ae768";
      };
    }

    {
      name = "defaults-1.0.3.tgz";
      path = fetchurl {
        name = "defaults-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/defaults/-/defaults-1.0.3.tgz";
        sha1 = "c656051e9817d9ff08ed881477f3fe4019f3ef7d";
      };
    }

    {
      name = "define-properties-1.1.3.tgz";
      path = fetchurl {
        name = "define-properties-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/define-properties/-/define-properties-1.1.3.tgz";
        sha1 = "cf88da6cbee26fe6db7094f61d870cbd84cee9f1";
      };
    }

    {
      name = "define-property-0.2.5.tgz";
      path = fetchurl {
        name = "define-property-0.2.5.tgz";
        url  = "https://registry.yarnpkg.com/define-property/-/define-property-0.2.5.tgz";
        sha1 = "c35b1ef918ec3c990f9a5bc57be04aacec5c8116";
      };
    }

    {
      name = "define-property-1.0.0.tgz";
      path = fetchurl {
        name = "define-property-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/define-property/-/define-property-1.0.0.tgz";
        sha1 = "769ebaaf3f4a63aad3af9e8d304c9bbe79bfb0e6";
      };
    }

    {
      name = "define-property-2.0.2.tgz";
      path = fetchurl {
        name = "define-property-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/define-property/-/define-property-2.0.2.tgz";
        sha1 = "d459689e8d654ba77e02a817f8710d702cb16e9d";
      };
    }

    {
      name = "del-2.2.2.tgz";
      path = fetchurl {
        name = "del-2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/del/-/del-2.2.2.tgz";
        sha1 = "c12c981d067846c84bcaf862cff930d907ffd1a8";
      };
    }

    {
      name = "delayed-stream-1.0.0.tgz";
      path = fetchurl {
        name = "delayed-stream-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz";
        sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
      };
    }

    {
      name = "delegate-3.2.0.tgz";
      path = fetchurl {
        name = "delegate-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/delegate/-/delegate-3.2.0.tgz";
        sha1 = "b66b71c3158522e8ab5744f720d8ca0c2af59166";
      };
    }

    {
      name = "delegates-1.0.0.tgz";
      path = fetchurl {
        name = "delegates-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz";
        sha1 = "84c6e159b81904fdca59a0ef44cd870d31250f9a";
      };
    }

    {
      name = "depd-1.1.1.tgz";
      path = fetchurl {
        name = "depd-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/depd/-/depd-1.1.1.tgz";
        sha1 = "5783b4e1c459f06fa5ca27f991f3d06e7a310359";
      };
    }

    {
      name = "depd-1.1.2.tgz";
      path = fetchurl {
        name = "depd-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/depd/-/depd-1.1.2.tgz";
        sha1 = "9bcd52e14c097763e749b274c4346ed2e560b5a9";
      };
    }

    {
      name = "des.js-1.0.0.tgz";
      path = fetchurl {
        name = "des.js-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/des.js/-/des.js-1.0.0.tgz";
        sha1 = "c074d2e2aa6a8a9a07dbd61f9a15c2cd83ec8ecc";
      };
    }

    {
      name = "destroy-1.0.4.tgz";
      path = fetchurl {
        name = "destroy-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/destroy/-/destroy-1.0.4.tgz";
        sha1 = "978857442c44749e4206613e37946205826abd80";
      };
    }

    {
      name = "detect-file-1.0.0.tgz";
      path = fetchurl {
        name = "detect-file-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/detect-file/-/detect-file-1.0.0.tgz";
        sha1 = "f0d66d03672a825cb1b73bdb3fe62310c8e552b7";
      };
    }

    {
      name = "detect-indent-4.0.0.tgz";
      path = fetchurl {
        name = "detect-indent-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/detect-indent/-/detect-indent-4.0.0.tgz";
        sha1 = "f76d064352cdf43a1cb6ce619c4ee3a9475de208";
      };
    }

    {
      name = "detect-indent-5.0.0.tgz";
      path = fetchurl {
        name = "detect-indent-5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/detect-indent/-/detect-indent-5.0.0.tgz";
        sha1 = "3871cc0a6a002e8c3e5b3cf7f336264675f06b9d";
      };
    }

    {
      name = "detect-libc-1.0.3.tgz";
      path = fetchurl {
        name = "detect-libc-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/detect-libc/-/detect-libc-1.0.3.tgz";
        sha1 = "fa137c4bd698edf55cd5cd02ac559f91a4c4ba9b";
      };
    }

    {
      name = "detect-newline-2.1.0.tgz";
      path = fetchurl {
        name = "detect-newline-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/detect-newline/-/detect-newline-2.1.0.tgz";
        sha1 = "f41f1c10be4b00e87b5f13da680759f2c5bfd3e2";
      };
    }

    {
      name = "dezalgo-1.0.3.tgz";
      path = fetchurl {
        name = "dezalgo-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/dezalgo/-/dezalgo-1.0.3.tgz";
        sha1 = "7f742de066fc748bc8db820569dddce49bf0d456";
      };
    }

    {
      name = "diagnostics-1.1.1.tgz";
      path = fetchurl {
        name = "diagnostics-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/diagnostics/-/diagnostics-1.1.1.tgz";
        sha1 = "cab6ac33df70c9d9a727490ae43ac995a769b22a";
      };
    }

    {
      name = "diff-1.0.7.tgz";
      path = fetchurl {
        name = "diff-1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/diff/-/diff-1.0.7.tgz";
        sha1 = "24bbb001c4a7d5522169e7cabdb2c2814ed91cf4";
      };
    }

    {
      name = "diff-3.5.0.tgz";
      path = fetchurl {
        name = "diff-3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/diff/-/diff-3.5.0.tgz";
        sha1 = "800c0dd1e0a8bfbc95835c202ad220fe317e5a12";
      };
    }

    {
      name = "diffie-hellman-5.0.3.tgz";
      path = fetchurl {
        name = "diffie-hellman-5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/diffie-hellman/-/diffie-hellman-5.0.3.tgz";
        sha1 = "40e8ee98f55a2149607146921c63e1ae5f3d2875";
      };
    }

    {
      name = "dir-glob-2.0.0.tgz";
      path = fetchurl {
        name = "dir-glob-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/dir-glob/-/dir-glob-2.0.0.tgz";
        sha1 = "0b205d2b6aef98238ca286598a8204d29d0a0034";
      };
    }

    {
      name = "dlv-1.1.2.tgz";
      path = fetchurl {
        name = "dlv-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/dlv/-/dlv-1.1.2.tgz";
        sha1 = "270f6737b30d25b6657a7e962c784403f85137e5";
      };
    }

    {
      name = "doctrine-2.1.0.tgz";
      path = fetchurl {
        name = "doctrine-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz";
        sha1 = "5cd01fc101621b42c4cd7f5d1a66243716d3f39d";
      };
    }

    {
      name = "dom-serializer-0.1.0.tgz";
      path = fetchurl {
        name = "dom-serializer-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-0.1.0.tgz";
        sha1 = "073c697546ce0780ce23be4a28e293e40bc30c82";
      };
    }

    {
      name = "dom-walk-0.1.1.tgz";
      path = fetchurl {
        name = "dom-walk-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/dom-walk/-/dom-walk-0.1.1.tgz";
        sha1 = "672226dc74c8f799ad35307df936aba11acd6018";
      };
    }

    {
      name = "domain-browser-1.2.0.tgz";
      path = fetchurl {
        name = "domain-browser-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/domain-browser/-/domain-browser-1.2.0.tgz";
        sha1 = "3d31f50191a6749dd1375a7f522e823d42e54eda";
      };
    }

    {
      name = "domelementtype-1.3.0.tgz";
      path = fetchurl {
        name = "domelementtype-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/domelementtype/-/domelementtype-1.3.0.tgz";
        sha1 = "b17aed82e8ab59e52dd9c19b1756e0fc187204c2";
      };
    }

    {
      name = "domelementtype-1.1.3.tgz";
      path = fetchurl {
        name = "domelementtype-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/domelementtype/-/domelementtype-1.1.3.tgz";
        sha1 = "bd28773e2642881aec51544924299c5cd822185b";
      };
    }

    {
      name = "domexception-1.0.1.tgz";
      path = fetchurl {
        name = "domexception-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/domexception/-/domexception-1.0.1.tgz";
        sha1 = "937442644ca6a31261ef36e3ec677fe805582c90";
      };
    }

    {
      name = "domhandler-2.3.0.tgz";
      path = fetchurl {
        name = "domhandler-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/domhandler/-/domhandler-2.3.0.tgz";
        sha1 = "2de59a0822d5027fabff6f032c2b25a2a8abe738";
      };
    }

    {
      name = "domutils-1.4.3.tgz";
      path = fetchurl {
        name = "domutils-1.4.3.tgz";
        url  = "https://registry.yarnpkg.com/domutils/-/domutils-1.4.3.tgz";
        sha1 = "0865513796c6b306031850e175516baf80b72a6f";
      };
    }

    {
      name = "domutils-1.5.1.tgz";
      path = fetchurl {
        name = "domutils-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/domutils/-/domutils-1.5.1.tgz";
        sha1 = "dcd8488a26f563d61079e48c9f7b7e32373682cf";
      };
    }

    {
      name = "dot-prop-3.0.0.tgz";
      path = fetchurl {
        name = "dot-prop-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/dot-prop/-/dot-prop-3.0.0.tgz";
        sha1 = "1b708af094a49c9a0e7dbcad790aba539dac1177";
      };
    }

    {
      name = "dot-prop-4.2.0.tgz";
      path = fetchurl {
        name = "dot-prop-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/dot-prop/-/dot-prop-4.2.0.tgz";
        sha1 = "1f19e0c2e1aa0e32797c49799f2837ac6af69c57";
      };
    }

    {
      name = "dotenv-5.0.1.tgz";
      path = fetchurl {
        name = "dotenv-5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/dotenv/-/dotenv-5.0.1.tgz";
        sha1 = "a5317459bd3d79ab88cff6e44057a6a3fbb1fcef";
      };
    }

    {
      name = "duplexer2-0.1.4.tgz";
      path = fetchurl {
        name = "duplexer2-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/duplexer2/-/duplexer2-0.1.4.tgz";
        sha1 = "8b12dab878c0d69e3e7891051662a32fc6bddcc1";
      };
    }

    {
      name = "duplexer3-0.1.4.tgz";
      path = fetchurl {
        name = "duplexer3-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/duplexer3/-/duplexer3-0.1.4.tgz";
        sha1 = "ee01dd1cac0ed3cbc7fdbea37dc0a8f1ce002ce2";
      };
    }

    {
      name = "duplexify-3.6.0.tgz";
      path = fetchurl {
        name = "duplexify-3.6.0.tgz";
        url  = "https://registry.yarnpkg.com/duplexify/-/duplexify-3.6.0.tgz";
        sha1 = "592903f5d80b38d037220541264d69a198fb3410";
      };
    }

    {
      name = "ecc-jsbn-0.1.2.tgz";
      path = fetchurl {
        name = "ecc-jsbn-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz";
        sha1 = "3a83a904e54353287874c564b7549386849a98c9";
      };
    }

    {
      name = "editions-1.3.4.tgz";
      path = fetchurl {
        name = "editions-1.3.4.tgz";
        url  = "https://registry.yarnpkg.com/editions/-/editions-1.3.4.tgz";
        sha1 = "3662cb592347c3168eb8e498a0ff73271d67f50b";
      };
    }

    {
      name = "editor-1.0.0.tgz";
      path = fetchurl {
        name = "editor-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/editor/-/editor-1.0.0.tgz";
        sha1 = "60c7f87bd62bcc6a894fa8ccd6afb7823a24f742";
      };
    }

    {
      name = "ee-first-1.1.1.tgz";
      path = fetchurl {
        name = "ee-first-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ee-first/-/ee-first-1.1.1.tgz";
        sha1 = "590c61156b0ae2f4f0255732a158b266bc56b21d";
      };
    }

    {
      name = "electron-to-chromium-1.3.64.tgz";
      path = fetchurl {
        name = "electron-to-chromium-1.3.64.tgz";
        url  = "https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.3.64.tgz";
        sha1 = "39f5a93bf84ab7e10cfbb7522ccfc3f1feb756cf";
      };
    }

    {
      name = "elliptic-6.4.1.tgz";
      path = fetchurl {
        name = "elliptic-6.4.1.tgz";
        url  = "https://registry.yarnpkg.com/elliptic/-/elliptic-6.4.1.tgz";
        sha1 = "c2d0b7776911b86722c632c3c06c60f2f819939a";
      };
    }

    {
      name = "ember-ajax-3.1.1.tgz";
      path = fetchurl {
        name = "ember-ajax-3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-ajax/-/ember-ajax-3.1.1.tgz";
        sha1 = "dcb55aaf1a9fe8b2ce04206863384709ebc2358b";
      };
    }

    {
      name = "ember-api-actions-0.1.9.tgz";
      path = fetchurl {
        name = "ember-api-actions-0.1.9.tgz";
        url  = "https://registry.yarnpkg.com/ember-api-actions/-/ember-api-actions-0.1.9.tgz";
        sha1 = "6a90af17bf79c42daa9b3b06b86a6f60bc098e7f";
      };
    }

    {
      name = "ember-assign-helper-0.1.2.tgz";
      path = fetchurl {
        name = "ember-assign-helper-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ember-assign-helper/-/ember-assign-helper-0.1.2.tgz";
        sha1 = "3d1d575f3d4457b3662b214d4c6e671bd462cad0";
      };
    }

    {
      name = "ember-auto-import-1.2.13.tgz";
      path = fetchurl {
        name = "ember-auto-import-1.2.13.tgz";
        url  = "https://registry.yarnpkg.com/ember-auto-import/-/ember-auto-import-1.2.13.tgz";
        sha1 = "8f6f5d1c64e173f9093dd0c5031dc1d446b7cff1";
      };
    }

    {
      name = "ember-basic-dropdown-hover-0.5.0.tgz";
      path = fetchurl {
        name = "ember-basic-dropdown-hover-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-basic-dropdown-hover/-/ember-basic-dropdown-hover-0.5.0.tgz";
        sha1 = "130b86d19442a8e8e855ea8009f7f991f59390f2";
      };
    }

    {
      name = "ember-basic-dropdown-1.0.3.tgz";
      path = fetchurl {
        name = "ember-basic-dropdown-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/ember-basic-dropdown/-/ember-basic-dropdown-1.0.3.tgz";
        sha1 = "bd785c84ea2b366951e0630f173c84677ed53b6c";
      };
    }

    {
      name = "ember-cli-autoprefixer-0.8.1.tgz";
      path = fetchurl {
        name = "ember-cli-autoprefixer-0.8.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-autoprefixer/-/ember-cli-autoprefixer-0.8.1.tgz";
        sha1 = "071dd9574451057b03dcc03b71f5bd9cb07ef332";
      };
    }

    {
      name = "ember-cli-babel-6.17.0.tgz";
      path = fetchurl {
        name = "ember-cli-babel-6.17.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-babel/-/ember-cli-babel-6.17.0.tgz";
        sha1 = "1f3e8ed9f4e2338caef6bc2c3d08d3c9928d0ddd";
      };
    }

    {
      name = "ember-cli-babel-6.17.1.tgz";
      path = fetchurl {
        name = "ember-cli-babel-6.17.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-babel/-/ember-cli-babel-6.17.1.tgz";
        sha1 = "db2d325da1975149b688177f44915903fa2ecb9f";
      };
    }

    {
      name = "ember-cli-broccoli-sane-watcher-2.1.1.tgz";
      path = fetchurl {
        name = "ember-cli-broccoli-sane-watcher-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-broccoli-sane-watcher/-/ember-cli-broccoli-sane-watcher-2.1.1.tgz";
        sha1 = "1687adada9022de26053fba833dc7dd10f03dd08";
      };
    }

    {
      name = "ember-cli-clipboard-0.8.1.tgz";
      path = fetchurl {
        name = "ember-cli-clipboard-0.8.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-clipboard/-/ember-cli-clipboard-0.8.1.tgz";
        sha1 = "59f8eb6ba471a7668dff592fcebb7b06014240dd";
      };
    }

    {
      name = "ember-cli-content-security-policy-1.0.0.tgz";
      path = fetchurl {
        name = "ember-cli-content-security-policy-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-content-security-policy/-/ember-cli-content-security-policy-1.0.0.tgz";
        sha1 = "4f7d72997d4209cd59f10d3b0070fdb39593ed2d";
      };
    }

    {
      name = "ember-cli-dependency-checker-3.0.0.tgz";
      path = fetchurl {
        name = "ember-cli-dependency-checker-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-dependency-checker/-/ember-cli-dependency-checker-3.0.0.tgz";
        sha1 = "61245f5f79f881dece043303111d5f41efb8621f";
      };
    }

    {
      name = "ember-cli-eslint-4.2.3.tgz";
      path = fetchurl {
        name = "ember-cli-eslint-4.2.3.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-eslint/-/ember-cli-eslint-4.2.3.tgz";
        sha1 = "2844d3f5e8184f19b2d7132ba99eb0b370b55598";
      };
    }

    {
      name = "ember-cli-favicon-1.0.0.tgz";
      path = fetchurl {
        name = "ember-cli-favicon-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-favicon/-/ember-cli-favicon-1.0.0.tgz";
        sha1 = "2f6781e939acf33b368841645e076bfd77061c34";
      };
    }

    {
      name = "ember-cli-flash-1.6.6.tgz";
      path = fetchurl {
        name = "ember-cli-flash-1.6.6.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-flash/-/ember-cli-flash-1.6.6.tgz";
        sha1 = "f3d005c8ac41ecd0ac6a00304adaa57c8a07bc36";
      };
    }

    {
      name = "ember-cli-get-component-path-option-1.0.0.tgz";
      path = fetchurl {
        name = "ember-cli-get-component-path-option-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-get-component-path-option/-/ember-cli-get-component-path-option-1.0.0.tgz";
        sha1 = "0d7b595559e2f9050abed804f1d8eff1b08bc771";
      };
    }

    {
      name = "ember-cli-htmlbars-inline-precompile-1.0.3.tgz";
      path = fetchurl {
        name = "ember-cli-htmlbars-inline-precompile-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-htmlbars-inline-precompile/-/ember-cli-htmlbars-inline-precompile-1.0.3.tgz";
        sha1 = "332ff96c06fc522965162f1090d78a615379c3c2";
      };
    }

    {
      name = "ember-cli-htmlbars-1.3.4.tgz";
      path = fetchurl {
        name = "ember-cli-htmlbars-1.3.4.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-htmlbars/-/ember-cli-htmlbars-1.3.4.tgz";
        sha1 = "461289724b34af372a6a0c4b6635819156963353";
      };
    }

    {
      name = "ember-cli-htmlbars-2.0.4.tgz";
      path = fetchurl {
        name = "ember-cli-htmlbars-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-htmlbars/-/ember-cli-htmlbars-2.0.4.tgz";
        sha1 = "0bcda483f14271663c38756e1fd1cb89da6a50cf";
      };
    }

    {
      name = "ember-cli-htmlbars-3.0.0.tgz";
      path = fetchurl {
        name = "ember-cli-htmlbars-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-htmlbars/-/ember-cli-htmlbars-3.0.0.tgz";
        sha1 = "4977b9eddbc725f8da25090ecdbba64533b2eadc";
      };
    }

    {
      name = "ember-cli-import-polyfill-0.2.0.tgz";
      path = fetchurl {
        name = "ember-cli-import-polyfill-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-import-polyfill/-/ember-cli-import-polyfill-0.2.0.tgz";
        sha1 = "c1a08a8affb45c97b675926272fe78cf4ca166f2";
      };
    }

    {
      name = "ember-cli-inject-live-reload-1.8.2.tgz";
      path = fetchurl {
        name = "ember-cli-inject-live-reload-1.8.2.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-inject-live-reload/-/ember-cli-inject-live-reload-1.8.2.tgz";
        sha1 = "29f875ad921e9a1dec65d2d75018891972d240bc";
      };
    }

    {
      name = "ember-cli-is-package-missing-1.0.0.tgz";
      path = fetchurl {
        name = "ember-cli-is-package-missing-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-is-package-missing/-/ember-cli-is-package-missing-1.0.0.tgz";
        sha1 = "6e6184cafb92635dd93ca6c946b104292d4e3390";
      };
    }

    {
      name = "ember-cli-lodash-subset-1.0.12.tgz";
      path = fetchurl {
        name = "ember-cli-lodash-subset-1.0.12.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-lodash-subset/-/ember-cli-lodash-subset-1.0.12.tgz";
        sha1 = "af2e77eba5dcb0d77f3308d3a6fd7d3450f6e537";
      };
    }

    {
      name = "ember-cli-lodash-subset-2.0.1.tgz";
      path = fetchurl {
        name = "ember-cli-lodash-subset-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-lodash-subset/-/ember-cli-lodash-subset-2.0.1.tgz";
        sha1 = "20cb68a790fe0fde2488ddfd8efbb7df6fe766f2";
      };
    }

    {
      name = "ember-cli-mirage-0.4.9.tgz";
      path = fetchurl {
        name = "ember-cli-mirage-0.4.9.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-mirage/-/ember-cli-mirage-0.4.9.tgz";
        sha1 = "c49bfe875d0cdf88c85a6ee55103d1980175b914";
      };
    }

    {
      name = "ember-cli-moment-shim-3.7.1.tgz";
      path = fetchurl {
        name = "ember-cli-moment-shim-3.7.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-moment-shim/-/ember-cli-moment-shim-3.7.1.tgz";
        sha1 = "3ad691c5027c1f38a4890fe47d74b5224cc98e32";
      };
    }

    {
      name = "ember-cli-node-assets-0.1.6.tgz";
      path = fetchurl {
        name = "ember-cli-node-assets-0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-node-assets/-/ember-cli-node-assets-0.1.6.tgz";
        sha1 = "6488a2949048c801ad6d9e33753c7bce32fc1146";
      };
    }

    {
      name = "ember-cli-node-assets-0.2.2.tgz";
      path = fetchurl {
        name = "ember-cli-node-assets-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-node-assets/-/ember-cli-node-assets-0.2.2.tgz";
        sha1 = "d2d55626e7cc6619f882d7fe55751f9266022708";
      };
    }

    {
      name = "ember-cli-normalize-entity-name-1.0.0.tgz";
      path = fetchurl {
        name = "ember-cli-normalize-entity-name-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-normalize-entity-name/-/ember-cli-normalize-entity-name-1.0.0.tgz";
        sha1 = "0b14f7bcbc599aa117b5fddc81e4fd03c4bad5b7";
      };
    }

    {
      name = "ember-cli-page-object-1.15.0-beta.3.tgz";
      path = fetchurl {
        name = "ember-cli-page-object-1.15.0-beta.3.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-page-object/-/ember-cli-page-object-1.15.0-beta.3.tgz";
        sha1 = "e41f3a33e35a6717c507b1a4c13fc990950c7d35";
      };
    }

    {
      name = "ember-cli-path-utils-1.0.0.tgz";
      path = fetchurl {
        name = "ember-cli-path-utils-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-path-utils/-/ember-cli-path-utils-1.0.0.tgz";
        sha1 = "4e39af8b55301cddc5017739b77a804fba2071ed";
      };
    }

    {
      name = "ember-cli-preprocess-registry-3.1.2.tgz";
      path = fetchurl {
        name = "ember-cli-preprocess-registry-3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-preprocess-registry/-/ember-cli-preprocess-registry-3.1.2.tgz";
        sha1 = "083efb21fd922c021ceba9e08f4d9278249fc4db";
      };
    }

    {
      name = "ember-cli-pretender-1.0.1.tgz";
      path = fetchurl {
        name = "ember-cli-pretender-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-pretender/-/ember-cli-pretender-1.0.1.tgz";
        sha1 = "35540babddef6f2778e91c627d190c73505103cd";
      };
    }

    {
      name = "ember-cli-qunit-4.3.2.tgz";
      path = fetchurl {
        name = "ember-cli-qunit-4.3.2.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-qunit/-/ember-cli-qunit-4.3.2.tgz";
        sha1 = "cfd89ad3b0dbc28a9c2223d532b52eeade7c602c";
      };
    }

    {
      name = "ember-cli-sass-7.2.0.tgz";
      path = fetchurl {
        name = "ember-cli-sass-7.2.0.tgz";
        url  = "http://registry.npmjs.org/ember-cli-sass/-/ember-cli-sass-7.2.0.tgz";
        sha1 = "293d1a94c43c1fdbb3835378e43d255e8ad5c961";
      };
    }

    {
      name = "1c0ff776a61f09121d1ea69ce16e4653da5e1efa";
      path = fetchurl {
        name = "1c0ff776a61f09121d1ea69ce16e4653da5e1efa";
        url  = "https://codeload.github.com/meirish/ember-cli-sri/tar.gz/1c0ff776a61f09121d1ea69ce16e4653da5e1efa";
        sha1 = "0f6ee264b58a3f8d6c415099f8d3193cde73d692";
      };
    }

    {
      name = "ember-cli-string-helpers-1.9.0.tgz";
      path = fetchurl {
        name = "ember-cli-string-helpers-1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-string-helpers/-/ember-cli-string-helpers-1.9.0.tgz";
        sha1 = "2c1605bc5768ff58cecd2fa1bd0d13d81e47f3d3";
      };
    }

    {
      name = "ember-cli-string-utils-1.1.0.tgz";
      path = fetchurl {
        name = "ember-cli-string-utils-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-string-utils/-/ember-cli-string-utils-1.1.0.tgz";
        sha1 = "39b677fc2805f55173735376fcef278eaa4452a1";
      };
    }

    {
      name = "ember-cli-template-lint-1.0.0-beta.2.tgz";
      path = fetchurl {
        name = "ember-cli-template-lint-1.0.0-beta.2.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-template-lint/-/ember-cli-template-lint-1.0.0-beta.2.tgz";
        sha1 = "0ebd2f8c1f9ca47f9ee3b42755d66262440c14f6";
      };
    }

    {
      name = "ember-cli-test-info-1.0.0.tgz";
      path = fetchurl {
        name = "ember-cli-test-info-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-test-info/-/ember-cli-test-info-1.0.0.tgz";
        sha1 = "ed4e960f249e97523cf891e4aed2072ce84577b4";
      };
    }

    {
      name = "ember-cli-test-loader-2.2.0.tgz";
      path = fetchurl {
        name = "ember-cli-test-loader-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-test-loader/-/ember-cli-test-loader-2.2.0.tgz";
        sha1 = "3fb8d5d1357e4460d3f0a092f5375e71b6f7c243";
      };
    }

    {
      name = "ember-cli-uglify-2.1.0.tgz";
      path = fetchurl {
        name = "ember-cli-uglify-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-uglify/-/ember-cli-uglify-2.1.0.tgz";
        sha1 = "4a0641fe4768d7ab7d4807aca9924cc77c544184";
      };
    }

    {
      name = "ember-cli-valid-component-name-1.0.0.tgz";
      path = fetchurl {
        name = "ember-cli-valid-component-name-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-valid-component-name/-/ember-cli-valid-component-name-1.0.0.tgz";
        sha1 = "71550ce387e0233065f30b30b1510aa2dfbe87ef";
      };
    }

    {
      name = "ember-cli-version-checker-1.3.1.tgz";
      path = fetchurl {
        name = "ember-cli-version-checker-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-version-checker/-/ember-cli-version-checker-1.3.1.tgz";
        sha1 = "0bc2d134c830142da64bf9627a0eded10b61ae72";
      };
    }

    {
      name = "ember-cli-version-checker-2.1.2.tgz";
      path = fetchurl {
        name = "ember-cli-version-checker-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli-version-checker/-/ember-cli-version-checker-2.1.2.tgz";
        sha1 = "305ce102390c66e4e0f1432dea9dc5c7c19fed98";
      };
    }

    {
      name = "ember-cli-3.4.2.tgz";
      path = fetchurl {
        name = "ember-cli-3.4.2.tgz";
        url  = "https://registry.yarnpkg.com/ember-cli/-/ember-cli-3.4.2.tgz";
        sha1 = "b1eee393ecb1bd0d41fcac25460f0c2a882de741";
      };
    }

    {
      name = "ember-compatibility-helpers-1.0.2.tgz";
      path = fetchurl {
        name = "ember-compatibility-helpers-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/ember-compatibility-helpers/-/ember-compatibility-helpers-1.0.2.tgz";
        sha1 = "a7eb8969747d063720fe44658af5448589b437ba";
      };
    }

    {
      name = "ember-composable-helpers-2.1.0.tgz";
      path = fetchurl {
        name = "ember-composable-helpers-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-composable-helpers/-/ember-composable-helpers-2.1.0.tgz";
        sha1 = "71f75ab2de1c696d21939b5f9dcc62eaf2c947e5";
      };
    }

    {
      name = "ember-computed-query-0.1.1.tgz";
      path = fetchurl {
        name = "ember-computed-query-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-computed-query/-/ember-computed-query-0.1.1.tgz";
        sha1 = "2e6debe36043c1271b5973ab19bf2f1931439ea0";
      };
    }

    {
      name = "ember-concurrency-0.8.20.tgz";
      path = fetchurl {
        name = "ember-concurrency-0.8.20.tgz";
        url  = "https://registry.yarnpkg.com/ember-concurrency/-/ember-concurrency-0.8.20.tgz";
        sha1 = "2c4f84ed3eb86cd0c7be9c2d21dd23f560757ac7";
      };
    }

    {
      name = "ember-copy-1.0.0.tgz";
      path = fetchurl {
        name = "ember-copy-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-copy/-/ember-copy-1.0.0.tgz";
        sha1 = "426554ba6cf65920f31d24d0a3ca2cb1be16e4aa";
      };
    }

    {
      name = "ember-data-model-fragments-3.3.0.tgz";
      path = fetchurl {
        name = "ember-data-model-fragments-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-data-model-fragments/-/ember-data-model-fragments-3.3.0.tgz";
        sha1 = "93e3ddba6fab2150435f995e07d25a4d88694886";
      };
    }

    {
      name = "ember-data-3.4.2.tgz";
      path = fetchurl {
        name = "ember-data-3.4.2.tgz";
        url  = "https://registry.yarnpkg.com/ember-data/-/ember-data-3.4.2.tgz";
        sha1 = "675cc4f1be8df1f5c0bfe4191afa6986377721c0";
      };
    }

    {
      name = "ember-export-application-global-2.0.0.tgz";
      path = fetchurl {
        name = "ember-export-application-global-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-export-application-global/-/ember-export-application-global-2.0.0.tgz";
        sha1 = "8d6d7619ac8a1a3f8c43003549eb21ebed685bd2";
      };
    }

    {
      name = "ember-factory-for-polyfill-1.3.1.tgz";
      path = fetchurl {
        name = "ember-factory-for-polyfill-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-factory-for-polyfill/-/ember-factory-for-polyfill-1.3.1.tgz";
        sha1 = "b446ed64916d293c847a4955240eb2c993b86eae";
      };
    }

    {
      name = "ember-fetch-3.4.5.tgz";
      path = fetchurl {
        name = "ember-fetch-3.4.5.tgz";
        url  = "https://registry.yarnpkg.com/ember-fetch/-/ember-fetch-3.4.5.tgz";
        sha1 = "2967df9cbdbe0993402588216332580be3950b92";
      };
    }

    {
      name = "ember-get-config-0.2.4.tgz";
      path = fetchurl {
        name = "ember-get-config-0.2.4.tgz";
        url  = "https://registry.yarnpkg.com/ember-get-config/-/ember-get-config-0.2.4.tgz";
        sha1 = "118492a2a03d73e46004ed777928942021fe1ecd";
      };
    }

    {
      name = "ember-getowner-polyfill-2.2.0.tgz";
      path = fetchurl {
        name = "ember-getowner-polyfill-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-getowner-polyfill/-/ember-getowner-polyfill-2.2.0.tgz";
        sha1 = "38e7dccbcac69d5ec694000329ec0b2be651d2b2";
      };
    }

    {
      name = "ember-inflector-2.3.0.tgz";
      path = fetchurl {
        name = "ember-inflector-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-inflector/-/ember-inflector-2.3.0.tgz";
        sha1 = "94797eba0eea98d902aa1e5da0f0aeef6053317f";
      };
    }

    {
      name = "ember-inflector-3.0.0.tgz";
      path = fetchurl {
        name = "ember-inflector-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-inflector/-/ember-inflector-3.0.0.tgz";
        sha1 = "7e1ee8aaa0fa773ba0905d8b7c0786354d890ee1";
      };
    }

    {
      name = "ember-load-initializers-1.1.0.tgz";
      path = fetchurl {
        name = "ember-load-initializers-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-load-initializers/-/ember-load-initializers-1.1.0.tgz";
        sha1 = "4edacc0f3a14d9f53d241ac3e5561804c8377978";
      };
    }

    {
      name = "ember-lodash-4.18.0.tgz";
      path = fetchurl {
        name = "ember-lodash-4.18.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-lodash/-/ember-lodash-4.18.0.tgz";
        sha1 = "45de700d6a4f68f1cd62888d90b50aa6477b9a83";
      };
    }

    {
      name = "ember-macro-helpers-0.17.1.tgz";
      path = fetchurl {
        name = "ember-macro-helpers-0.17.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-macro-helpers/-/ember-macro-helpers-0.17.1.tgz";
        sha1 = "34836e9158cc260ee1c540935371d11f52ec98d9";
      };
    }

    {
      name = "ember-maybe-import-regenerator-0.1.6.tgz";
      path = fetchurl {
        name = "ember-maybe-import-regenerator-0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/ember-maybe-import-regenerator/-/ember-maybe-import-regenerator-0.1.6.tgz";
        sha1 = "35d41828afa6d6a59bc0da3ce47f34c573d776ca";
      };
    }

    {
      name = "ember-maybe-in-element-0.1.3.tgz";
      path = fetchurl {
        name = "ember-maybe-in-element-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/ember-maybe-in-element/-/ember-maybe-in-element-0.1.3.tgz";
        sha1 = "1c89be49246e580c1090336ad8be31e373f71b60";
      };
    }

    {
      name = "ember-moment-7.7.0.tgz";
      path = fetchurl {
        name = "ember-moment-7.7.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-moment/-/ember-moment-7.7.0.tgz";
        sha1 = "febf7cc5bfc665c8f1d45fa24e5c7a5f5f91afa5";
      };
    }

    {
      name = "ember-native-dom-helpers-0.5.10.tgz";
      path = fetchurl {
        name = "ember-native-dom-helpers-0.5.10.tgz";
        url  = "https://registry.yarnpkg.com/ember-native-dom-helpers/-/ember-native-dom-helpers-0.5.10.tgz";
        sha1 = "9c7172e4ddfa5dd86830c46a936e2f8eca3e5896";
      };
    }

    {
      name = "ember-qunit-3.4.1.tgz";
      path = fetchurl {
        name = "ember-qunit-3.4.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-qunit/-/ember-qunit-3.4.1.tgz";
        sha1 = "204a2d39a5d44d494c56bf17cf3fd12f06210359";
      };
    }

    {
      name = "ember-radio-button-1.2.4.tgz";
      path = fetchurl {
        name = "ember-radio-button-1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/ember-radio-button/-/ember-radio-button-1.2.4.tgz";
        sha1 = "7ca1ac03f79036954dbeeb2926350965ee4db497";
      };
    }

    {
      name = "ember-resolver-5.0.1.tgz";
      path = fetchurl {
        name = "ember-resolver-5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-resolver/-/ember-resolver-5.0.1.tgz";
        sha1 = "21740b92e1e4a65f94018de22aa1c73434dc3b2f";
      };
    }

    {
      name = "ember-responsive-3.0.0-beta.3.tgz";
      path = fetchurl {
        name = "ember-responsive-3.0.0-beta.3.tgz";
        url  = "https://registry.yarnpkg.com/ember-responsive/-/ember-responsive-3.0.0-beta.3.tgz";
        sha1 = "63f4f5cad179399e40cd6a591bb2677c4cc0a874";
      };
    }

    {
      name = "ember-rfc176-data-0.3.3.tgz";
      path = fetchurl {
        name = "ember-rfc176-data-0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/ember-rfc176-data/-/ember-rfc176-data-0.3.3.tgz";
        sha1 = "27fba08d540a7463a4366c48eaa19c5a44971a39";
      };
    }

    {
      name = "ember-rfc176-data-0.3.4.tgz";
      path = fetchurl {
        name = "ember-rfc176-data-0.3.4.tgz";
        url  = "https://registry.yarnpkg.com/ember-rfc176-data/-/ember-rfc176-data-0.3.4.tgz";
        sha1 = "566fd3b7192d02a9a0bfe7e22bbaa4d3a1682e4a";
      };
    }

    {
      name = "ember-router-generator-1.2.3.tgz";
      path = fetchurl {
        name = "ember-router-generator-1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/ember-router-generator/-/ember-router-generator-1.2.3.tgz";
        sha1 = "8ed2ca86ff323363120fc14278191e9e8f1315ee";
      };
    }

    {
      name = "ember-runtime-enumerable-includes-polyfill-2.1.0.tgz";
      path = fetchurl {
        name = "ember-runtime-enumerable-includes-polyfill-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-runtime-enumerable-includes-polyfill/-/ember-runtime-enumerable-includes-polyfill-2.1.0.tgz";
        sha1 = "dc6d4a028471e4acc350dfd2a149874fb20913f5";
      };
    }

    {
      name = "ember-sinon-1.0.1.tgz";
      path = fetchurl {
        name = "ember-sinon-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-sinon/-/ember-sinon-1.0.1.tgz";
        sha1 = "056390eacc9367b4c3955ce1cb5a04246f8197f5";
      };
    }

    {
      name = "ember-source-3.4.1.tgz";
      path = fetchurl {
        name = "ember-source-3.4.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-source/-/ember-source-3.4.1.tgz";
        sha1 = "75cfc19bd54ad006729c8ec12539901308e8cef0";
      };
    }

    {
      name = "ember-template-lint-1.0.0-beta.5.tgz";
      path = fetchurl {
        name = "ember-template-lint-1.0.0-beta.5.tgz";
        url  = "https://registry.yarnpkg.com/ember-template-lint/-/ember-template-lint-1.0.0-beta.5.tgz";
        sha1 = "b9c3459752b9fb6c93f676f5a99e18372ad60af2";
      };
    }

    {
      name = "ember-test-selectors-1.0.0.tgz";
      path = fetchurl {
        name = "ember-test-selectors-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-test-selectors/-/ember-test-selectors-1.0.0.tgz";
        sha1 = "a2f8cd86f4fb4c320004a2bf0e4c450d41668a21";
      };
    }

    {
      name = "ember-truth-helpers-2.1.0.tgz";
      path = fetchurl {
        name = "ember-truth-helpers-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ember-truth-helpers/-/ember-truth-helpers-2.1.0.tgz";
        sha1 = "d4dab4eee7945aa2388126485977baeb33ca0798";
      };
    }

    {
      name = "ember-weakmap-3.3.1.tgz";
      path = fetchurl {
        name = "ember-weakmap-3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/ember-weakmap/-/ember-weakmap-3.3.1.tgz";
        sha1 = "5188b035f5bfb17397067ea635300ae4e1205e11";
      };
    }

    {
      name = "emojis-list-2.1.0.tgz";
      path = fetchurl {
        name = "emojis-list-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/emojis-list/-/emojis-list-2.1.0.tgz";
        sha1 = "4daa4d9db00f9819880c79fa457ae5b09a1fd389";
      };
    }

    {
      name = "enabled-1.0.2.tgz";
      path = fetchurl {
        name = "enabled-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/enabled/-/enabled-1.0.2.tgz";
        sha1 = "965f6513d2c2d1c5f4652b64a2e3396467fc2f93";
      };
    }

    {
      name = "encodeurl-1.0.2.tgz";
      path = fetchurl {
        name = "encodeurl-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz";
        sha1 = "ad3ff4c86ec2d029322f5a02c3a9a606c95b3f59";
      };
    }

    {
      name = "encoding-0.1.12.tgz";
      path = fetchurl {
        name = "encoding-0.1.12.tgz";
        url  = "https://registry.yarnpkg.com/encoding/-/encoding-0.1.12.tgz";
        sha1 = "538b66f3ee62cd1ab51ec323829d1f9480c74beb";
      };
    }

    {
      name = "end-of-stream-1.4.1.tgz";
      path = fetchurl {
        name = "end-of-stream-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.1.tgz";
        sha1 = "ed29634d19baba463b6ce6b80a37213eab71ec43";
      };
    }

    {
      name = "engine.io-client-3.2.1.tgz";
      path = fetchurl {
        name = "engine.io-client-3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/engine.io-client/-/engine.io-client-3.2.1.tgz";
        sha1 = "6f54c0475de487158a1a7c77d10178708b6add36";
      };
    }

    {
      name = "engine.io-parser-2.1.2.tgz";
      path = fetchurl {
        name = "engine.io-parser-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/engine.io-parser/-/engine.io-parser-2.1.2.tgz";
        sha1 = "4c0f4cff79aaeecbbdcfdea66a823c6085409196";
      };
    }

    {
      name = "engine.io-3.2.0.tgz";
      path = fetchurl {
        name = "engine.io-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/engine.io/-/engine.io-3.2.0.tgz";
        sha1 = "54332506f42f2edc71690d2f2a42349359f3bf7d";
      };
    }

    {
      name = "enhanced-resolve-4.1.0.tgz";
      path = fetchurl {
        name = "enhanced-resolve-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-4.1.0.tgz";
        sha1 = "41c7e0bfdfe74ac1ffe1e57ad6a5c6c9f3742a7f";
      };
    }

    {
      name = "ensure-posix-path-1.0.2.tgz";
      path = fetchurl {
        name = "ensure-posix-path-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/ensure-posix-path/-/ensure-posix-path-1.0.2.tgz";
        sha1 = "a65b3e42d0b71cfc585eb774f9943c8d9b91b0c2";
      };
    }

    {
      name = "entities-1.0.0.tgz";
      path = fetchurl {
        name = "entities-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/entities/-/entities-1.0.0.tgz";
        sha1 = "b2987aa3821347fcde642b24fdfc9e4fb712bf26";
      };
    }

    {
      name = "entities-1.1.1.tgz";
      path = fetchurl {
        name = "entities-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/entities/-/entities-1.1.1.tgz";
        sha1 = "6e5c2d0a5621b5dadaecef80b90edfb5cd7772f0";
      };
    }

    {
      name = "env-ci-2.4.0.tgz";
      path = fetchurl {
        name = "env-ci-2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/env-ci/-/env-ci-2.4.0.tgz";
        sha1 = "1ceacee17a6860fffa04436cea586d15534b4c4d";
      };
    }

    {
      name = "env-variable-0.0.4.tgz";
      path = fetchurl {
        name = "env-variable-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/env-variable/-/env-variable-0.0.4.tgz";
        sha1 = "0d6280cf507d84242befe35a512b5ae4be77c54e";
      };
    }

    {
      name = "err-code-1.1.2.tgz";
      path = fetchurl {
        name = "err-code-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/err-code/-/err-code-1.1.2.tgz";
        sha1 = "06e0116d3028f6aef4806849eb0ea6a748ae6960";
      };
    }

    {
      name = "errno-0.1.7.tgz";
      path = fetchurl {
        name = "errno-0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/errno/-/errno-0.1.7.tgz";
        sha1 = "4684d71779ad39af177e3f007996f7c67c852618";
      };
    }

    {
      name = "error-ex-1.3.2.tgz";
      path = fetchurl {
        name = "error-ex-1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz";
        sha1 = "b4ac40648107fdcdcfae242f428bea8a14d4f1bf";
      };
    }

    {
      name = "error-7.0.2.tgz";
      path = fetchurl {
        name = "error-7.0.2.tgz";
        url  = "https://registry.yarnpkg.com/error/-/error-7.0.2.tgz";
        sha1 = "a5f75fff4d9926126ddac0ea5dc38e689153cb02";
      };
    }

    {
      name = "es-abstract-1.12.0.tgz";
      path = fetchurl {
        name = "es-abstract-1.12.0.tgz";
        url  = "https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.12.0.tgz";
        sha1 = "9dbbdd27c6856f0001421ca18782d786bf8a6165";
      };
    }

    {
      name = "es-to-primitive-1.1.1.tgz";
      path = fetchurl {
        name = "es-to-primitive-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.1.1.tgz";
        sha1 = "45355248a88979034b6792e19bb81f2b7975dd0d";
      };
    }

    {
      name = "es6-promise-3.3.1.tgz";
      path = fetchurl {
        name = "es6-promise-3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/es6-promise/-/es6-promise-3.3.1.tgz";
        sha1 = "a08cdde84ccdbf34d027a1451bc91d4bcd28a613";
      };
    }

    {
      name = "es6-promise-4.2.4.tgz";
      path = fetchurl {
        name = "es6-promise-4.2.4.tgz";
        url  = "https://registry.yarnpkg.com/es6-promise/-/es6-promise-4.2.4.tgz";
        sha1 = "dc4221c2b16518760bd8c39a52d8f356fc00ed29";
      };
    }

    {
      name = "es6-promisify-5.0.0.tgz";
      path = fetchurl {
        name = "es6-promisify-5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/es6-promisify/-/es6-promisify-5.0.0.tgz";
        sha1 = "5109d62f3e56ea967c4b63505aef08291c8a5203";
      };
    }

    {
      name = "escape-html-1.0.3.tgz";
      path = fetchurl {
        name = "escape-html-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/escape-html/-/escape-html-1.0.3.tgz";
        sha1 = "0258eae4d3d0c0974de1c169188ef0051d1d1988";
      };
    }

    {
      name = "escape-string-regexp-1.0.5.tgz";
      path = fetchurl {
        name = "escape-string-regexp-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
        sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
      };
    }

    {
      name = "escodegen-1.11.0.tgz";
      path = fetchurl {
        name = "escodegen-1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/escodegen/-/escodegen-1.11.0.tgz";
        sha1 = "b27a9389481d5bfd5bec76f7bb1eb3f8f4556589";
      };
    }

    {
      name = "eslint-plugin-ember-5.2.0.tgz";
      path = fetchurl {
        name = "eslint-plugin-ember-5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-ember/-/eslint-plugin-ember-5.2.0.tgz";
        sha1 = "fa436e0497dfc01d1d38608229cd616e7c5b6067";
      };
    }

    {
      name = "eslint-scope-3.7.3.tgz";
      path = fetchurl {
        name = "eslint-scope-3.7.3.tgz";
        url  = "https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-3.7.3.tgz";
        sha1 = "bb507200d3d17f60247636160b4826284b108535";
      };
    }

    {
      name = "eslint-scope-4.0.0.tgz";
      path = fetchurl {
        name = "eslint-scope-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-4.0.0.tgz";
        sha1 = "50bf3071e9338bcdc43331794a0cb533f0136172";
      };
    }

    {
      name = "eslint-visitor-keys-1.0.0.tgz";
      path = fetchurl {
        name = "eslint-visitor-keys-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.0.0.tgz";
        sha1 = "3f3180fb2e291017716acb4c9d6d5b5c34a6a81d";
      };
    }

    {
      name = "eslint-4.19.1.tgz";
      path = fetchurl {
        name = "eslint-4.19.1.tgz";
        url  = "http://registry.npmjs.org/eslint/-/eslint-4.19.1.tgz";
        sha1 = "32d1d653e1d90408854bfb296f076ec7e186a300";
      };
    }

    {
      name = "espree-3.5.4.tgz";
      path = fetchurl {
        name = "espree-3.5.4.tgz";
        url  = "https://registry.yarnpkg.com/espree/-/espree-3.5.4.tgz";
        sha1 = "b0f447187c8a8bed944b815a660bddf5deb5d1a7";
      };
    }

    {
      name = "esprima-3.1.3.tgz";
      path = fetchurl {
        name = "esprima-3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-3.1.3.tgz";
        sha1 = "fdca51cee6133895e3c88d535ce49dbff62a4633";
      };
    }

    {
      name = "esprima-4.0.1.tgz";
      path = fetchurl {
        name = "esprima-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz";
        sha1 = "13b04cdb3e6c5d19df91ab6987a8695619b0aa71";
      };
    }

    {
      name = "esprima-3.0.0.tgz";
      path = fetchurl {
        name = "esprima-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-3.0.0.tgz";
        sha1 = "53cf247acda77313e551c3aa2e73342d3fb4f7d9";
      };
    }

    {
      name = "esquery-1.0.1.tgz";
      path = fetchurl {
        name = "esquery-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/esquery/-/esquery-1.0.1.tgz";
        sha1 = "406c51658b1f5991a5f9b62b1dc25b00e3e5c708";
      };
    }

    {
      name = "esrecurse-4.2.1.tgz";
      path = fetchurl {
        name = "esrecurse-4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.2.1.tgz";
        sha1 = "007a3b9fdbc2b3bb87e4879ea19c92fdbd3942cf";
      };
    }

    {
      name = "estraverse-4.2.0.tgz";
      path = fetchurl {
        name = "estraverse-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-4.2.0.tgz";
        sha1 = "0dee3fed31fcd469618ce7342099fc1afa0bdb13";
      };
    }

    {
      name = "estree-walker-0.5.2.tgz";
      path = fetchurl {
        name = "estree-walker-0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/estree-walker/-/estree-walker-0.5.2.tgz";
        sha1 = "d3850be7529c9580d815600b53126515e146dd39";
      };
    }

    {
      name = "esutils-2.0.2.tgz";
      path = fetchurl {
        name = "esutils-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/esutils/-/esutils-2.0.2.tgz";
        sha1 = "0abf4f1caa5bcb1f7a9d8acc6dea4faaa04bac9b";
      };
    }

    {
      name = "etag-1.8.1.tgz";
      path = fetchurl {
        name = "etag-1.8.1.tgz";
        url  = "https://registry.yarnpkg.com/etag/-/etag-1.8.1.tgz";
        sha1 = "41ae2eeb65efa62268aebfea83ac7d79299b0887";
      };
    }

    {
      name = "eventemitter3-3.1.0.tgz";
      path = fetchurl {
        name = "eventemitter3-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/eventemitter3/-/eventemitter3-3.1.0.tgz";
        sha1 = "090b4d6cdbd645ed10bf750d4b5407942d7ba163";
      };
    }

    {
      name = "events-to-array-1.1.2.tgz";
      path = fetchurl {
        name = "events-to-array-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/events-to-array/-/events-to-array-1.1.2.tgz";
        sha1 = "2d41f563e1fe400ed4962fe1a4d5c6a7539df7f6";
      };
    }

    {
      name = "events-1.1.1.tgz";
      path = fetchurl {
        name = "events-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/events/-/events-1.1.1.tgz";
        sha1 = "9ebdb7635ad099c70dcc4c2a1f5004288e8bd924";
      };
    }

    {
      name = "evp_bytestokey-1.0.3.tgz";
      path = fetchurl {
        name = "evp_bytestokey-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/evp_bytestokey/-/evp_bytestokey-1.0.3.tgz";
        sha1 = "7fcbdb198dc71959432efe13842684e0525acb02";
      };
    }

    {
      name = "exec-file-sync-2.0.2.tgz";
      path = fetchurl {
        name = "exec-file-sync-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/exec-file-sync/-/exec-file-sync-2.0.2.tgz";
        sha1 = "58d441db46e40de6d1f30de5be022785bd89e328";
      };
    }

    {
      name = "exec-sh-0.2.2.tgz";
      path = fetchurl {
        name = "exec-sh-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/exec-sh/-/exec-sh-0.2.2.tgz";
        sha1 = "2a5e7ffcbd7d0ba2755bdecb16e5a427dfbdec36";
      };
    }

    {
      name = "execa-0.10.0.tgz";
      path = fetchurl {
        name = "execa-0.10.0.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-0.10.0.tgz";
        sha1 = "ff456a8f53f90f8eccc71a96d11bdfc7f082cb50";
      };
    }

    {
      name = "execa-0.11.0.tgz";
      path = fetchurl {
        name = "execa-0.11.0.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-0.11.0.tgz";
        sha1 = "0b3c71daf9b9159c252a863cd981af1b4410d97a";
      };
    }

    {
      name = "execa-0.7.0.tgz";
      path = fetchurl {
        name = "execa-0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-0.7.0.tgz";
        sha1 = "944becd34cc41ee32a63a9faf27ad5a65fc59777";
      };
    }

    {
      name = "execa-1.0.0.tgz";
      path = fetchurl {
        name = "execa-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-1.0.0.tgz";
        sha1 = "c6236a5bb4df6d6f15e88e7f017798216749ddd8";
      };
    }

    {
      name = "exif-parser-0.1.12.tgz";
      path = fetchurl {
        name = "exif-parser-0.1.12.tgz";
        url  = "https://registry.yarnpkg.com/exif-parser/-/exif-parser-0.1.12.tgz";
        sha1 = "58a9d2d72c02c1f6f02a0ef4a9166272b7760922";
      };
    }

    {
      name = "exists-stat-1.0.0.tgz";
      path = fetchurl {
        name = "exists-stat-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/exists-stat/-/exists-stat-1.0.0.tgz";
        sha1 = "0660e3525a2e89d9e446129440c272edfa24b529";
      };
    }

    {
      name = "exists-sync-0.0.4.tgz";
      path = fetchurl {
        name = "exists-sync-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/exists-sync/-/exists-sync-0.0.4.tgz";
        sha1 = "9744c2c428cc03b01060db454d4b12f0ef3c8879";
      };
    }

    {
      name = "exit-hook-1.1.1.tgz";
      path = fetchurl {
        name = "exit-hook-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/exit-hook/-/exit-hook-1.1.1.tgz";
        sha1 = "f05ca233b48c05d54fff07765df8507e95c02ff8";
      };
    }

    {
      name = "exit-0.1.2.tgz";
      path = fetchurl {
        name = "exit-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/exit/-/exit-0.1.2.tgz";
        sha1 = "0632638f8d877cc82107d30a0fff1a17cba1cd0c";
      };
    }

    {
      name = "expand-brackets-0.1.5.tgz";
      path = fetchurl {
        name = "expand-brackets-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-0.1.5.tgz";
        sha1 = "df07284e342a807cd733ac5af72411e581d1177b";
      };
    }

    {
      name = "expand-brackets-2.1.4.tgz";
      path = fetchurl {
        name = "expand-brackets-2.1.4.tgz";
        url  = "https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-2.1.4.tgz";
        sha1 = "b77735e315ce30f6b6eff0f83b04151a22449622";
      };
    }

    {
      name = "expand-range-1.8.2.tgz";
      path = fetchurl {
        name = "expand-range-1.8.2.tgz";
        url  = "https://registry.yarnpkg.com/expand-range/-/expand-range-1.8.2.tgz";
        sha1 = "a299effd335fe2721ebae8e257ec79644fc85337";
      };
    }

    {
      name = "expand-tilde-2.0.2.tgz";
      path = fetchurl {
        name = "expand-tilde-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/expand-tilde/-/expand-tilde-2.0.2.tgz";
        sha1 = "97e801aa052df02454de46b02bf621642cdc8502";
      };
    }

    {
      name = "express-4.16.3.tgz";
      path = fetchurl {
        name = "express-4.16.3.tgz";
        url  = "http://registry.npmjs.org/express/-/express-4.16.3.tgz";
        sha1 = "6af8a502350db3246ecc4becf6b5a34d22f7ed53";
      };
    }

    {
      name = "extend-shallow-2.0.1.tgz";
      path = fetchurl {
        name = "extend-shallow-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-2.0.1.tgz";
        sha1 = "51af7d614ad9a9f610ea1bafbb989d6b1c56890f";
      };
    }

    {
      name = "extend-shallow-3.0.2.tgz";
      path = fetchurl {
        name = "extend-shallow-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-3.0.2.tgz";
        sha1 = "26a71aaf073b39fb2127172746131c2704028db8";
      };
    }

    {
      name = "extend-3.0.2.tgz";
      path = fetchurl {
        name = "extend-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz";
        sha1 = "f8b1136b4071fbd8eb140aff858b1019ec2915fa";
      };
    }

    {
      name = "external-editor-1.1.1.tgz";
      path = fetchurl {
        name = "external-editor-1.1.1.tgz";
        url  = "http://registry.npmjs.org/external-editor/-/external-editor-1.1.1.tgz";
        sha1 = "12d7b0db850f7ff7e7081baf4005700060c4600b";
      };
    }

    {
      name = "external-editor-2.2.0.tgz";
      path = fetchurl {
        name = "external-editor-2.2.0.tgz";
        url  = "http://registry.npmjs.org/external-editor/-/external-editor-2.2.0.tgz";
        sha1 = "045511cfd8d133f3846673d1047c154e214ad3d5";
      };
    }

    {
      name = "extglob-0.3.2.tgz";
      path = fetchurl {
        name = "extglob-0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/extglob/-/extglob-0.3.2.tgz";
        sha1 = "2e18ff3d2f49ab2765cec9023f011daa8d8349a1";
      };
    }

    {
      name = "extglob-2.0.4.tgz";
      path = fetchurl {
        name = "extglob-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/extglob/-/extglob-2.0.4.tgz";
        sha1 = "ad00fe4dc612a9232e8718711dc5cb5ab0285543";
      };
    }

    {
      name = "extract-zip-1.6.7.tgz";
      path = fetchurl {
        name = "extract-zip-1.6.7.tgz";
        url  = "https://registry.yarnpkg.com/extract-zip/-/extract-zip-1.6.7.tgz";
        sha1 = "a840b4b8af6403264c8db57f4f1a74333ef81fe9";
      };
    }

    {
      name = "extsprintf-1.3.0.tgz";
      path = fetchurl {
        name = "extsprintf-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.3.0.tgz";
        sha1 = "96918440e3041a7a414f8c52e3c574eb3c3e1e05";
      };
    }

    {
      name = "extsprintf-1.4.0.tgz";
      path = fetchurl {
        name = "extsprintf-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.4.0.tgz";
        sha1 = "e2689f8f356fad62cca65a3a91c5df5f9551692f";
      };
    }

    {
      name = "fake-xml-http-request-1.6.0.tgz";
      path = fetchurl {
        name = "fake-xml-http-request-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/fake-xml-http-request/-/fake-xml-http-request-1.6.0.tgz";
        sha1 = "bd0ac79ae3e2660098282048a12c730a6f64d550";
      };
    }

    {
      name = "faker-3.1.0.tgz";
      path = fetchurl {
        name = "faker-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/faker/-/faker-3.1.0.tgz";
        sha1 = "0f908faf4e6ec02524e54a57e432c5c013e08c9f";
      };
    }

    {
      name = "fast-deep-equal-1.1.0.tgz";
      path = fetchurl {
        name = "fast-deep-equal-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-1.1.0.tgz";
        sha1 = "c053477817c86b51daa853c81e059b733d023614";
      };
    }

    {
      name = "fast-deep-equal-2.0.1.tgz";
      path = fetchurl {
        name = "fast-deep-equal-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-2.0.1.tgz";
        sha1 = "7b05218ddf9667bf7f370bf7fdb2cb15fdd0aa49";
      };
    }

    {
      name = "fast-glob-2.2.2.tgz";
      path = fetchurl {
        name = "fast-glob-2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/fast-glob/-/fast-glob-2.2.2.tgz";
        sha1 = "71723338ac9b4e0e2fff1d6748a2a13d5ed352bf";
      };
    }

    {
      name = "fast-json-stable-stringify-2.0.0.tgz";
      path = fetchurl {
        name = "fast-json-stable-stringify-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.0.0.tgz";
        sha1 = "d5142c0caee6b1189f87d3a76111064f86c8bbf2";
      };
    }

    {
      name = "fast-levenshtein-2.0.6.tgz";
      path = fetchurl {
        name = "fast-levenshtein-2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz";
        sha1 = "3d8a5c66883a16a30ca8643e851f19baa7797917";
      };
    }

    {
      name = "fast-ordered-set-1.0.3.tgz";
      path = fetchurl {
        name = "fast-ordered-set-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/fast-ordered-set/-/fast-ordered-set-1.0.3.tgz";
        sha1 = "3fbb36634f7be79e4f7edbdb4a357dee25d184eb";
      };
    }

    {
      name = "fast-safe-stringify-2.0.6.tgz";
      path = fetchurl {
        name = "fast-safe-stringify-2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/fast-safe-stringify/-/fast-safe-stringify-2.0.6.tgz";
        sha1 = "04b26106cc56681f51a044cfc0d76cf0008ac2c2";
      };
    }

    {
      name = "fast-sourcemap-concat-1.4.0.tgz";
      path = fetchurl {
        name = "fast-sourcemap-concat-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-sourcemap-concat/-/fast-sourcemap-concat-1.4.0.tgz";
        sha1 = "122c330d4a2afaff16ad143bc9674b87cd76c8ad";
      };
    }

    {
      name = "fastboot-transform-0.1.1.tgz";
      path = fetchurl {
        name = "fastboot-transform-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/fastboot-transform/-/fastboot-transform-0.1.1.tgz";
        sha1 = "de55550d85644ec94cb11264c2ba883e3ea3b255";
      };
    }

    {
      name = "favicons-4.8.6.tgz";
      path = fetchurl {
        name = "favicons-4.8.6.tgz";
        url  = "https://registry.yarnpkg.com/favicons/-/favicons-4.8.6.tgz";
        sha1 = "a2b13800ab3fec2715bc8f27fa841d038d4761e2";
      };
    }

    {
      name = "faye-websocket-0.10.0.tgz";
      path = fetchurl {
        name = "faye-websocket-0.10.0.tgz";
        url  = "https://registry.yarnpkg.com/faye-websocket/-/faye-websocket-0.10.0.tgz";
        sha1 = "4e492f8d04dfb6f89003507f6edbf2d501e7c6f4";
      };
    }

    {
      name = "fb-watchman-2.0.0.tgz";
      path = fetchurl {
        name = "fb-watchman-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fb-watchman/-/fb-watchman-2.0.0.tgz";
        sha1 = "54e9abf7dfa2f26cd9b1636c588c1afc05de5d58";
      };
    }

    {
      name = "fd-slicer-1.0.1.tgz";
      path = fetchurl {
        name = "fd-slicer-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.0.1.tgz";
        sha1 = "8b5bcbd9ec327c5041bf9ab023fd6750f1177e65";
      };
    }

    {
      name = "fecha-2.3.3.tgz";
      path = fetchurl {
        name = "fecha-2.3.3.tgz";
        url  = "https://registry.yarnpkg.com/fecha/-/fecha-2.3.3.tgz";
        sha1 = "948e74157df1a32fd1b12c3a3c3cdcb6ec9d96cd";
      };
    }

    {
      name = "figgy-pudding-3.5.1.tgz";
      path = fetchurl {
        name = "figgy-pudding-3.5.1.tgz";
        url  = "https://registry.yarnpkg.com/figgy-pudding/-/figgy-pudding-3.5.1.tgz";
        sha1 = "862470112901c727a0e495a80744bd5baa1d6790";
      };
    }

    {
      name = "figures-2.0.0.tgz";
      path = fetchurl {
        name = "figures-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/figures/-/figures-2.0.0.tgz";
        sha1 = "3ab1a2d2a62c8bfb431a0c94cb797a2fce27c962";
      };
    }

    {
      name = "file-entry-cache-2.0.0.tgz";
      path = fetchurl {
        name = "file-entry-cache-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-2.0.0.tgz";
        sha1 = "c392990c3e684783d838b8c84a45d8a048458361";
      };
    }

    {
      name = "file-type-3.9.0.tgz";
      path = fetchurl {
        name = "file-type-3.9.0.tgz";
        url  = "https://registry.yarnpkg.com/file-type/-/file-type-3.9.0.tgz";
        sha1 = "257a078384d1db8087bc449d107d52a52672b9e9";
      };
    }

    {
      name = "filename-regex-2.0.1.tgz";
      path = fetchurl {
        name = "filename-regex-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/filename-regex/-/filename-regex-2.0.1.tgz";
        sha1 = "c1c4b9bee3e09725ddb106b75c1e301fe2f18b26";
      };
    }

    {
      name = "filesize-3.6.1.tgz";
      path = fetchurl {
        name = "filesize-3.6.1.tgz";
        url  = "https://registry.yarnpkg.com/filesize/-/filesize-3.6.1.tgz";
        sha1 = "090bb3ee01b6f801a8a8be99d31710b3422bb317";
      };
    }

    {
      name = "fill-range-2.2.4.tgz";
      path = fetchurl {
        name = "fill-range-2.2.4.tgz";
        url  = "https://registry.yarnpkg.com/fill-range/-/fill-range-2.2.4.tgz";
        sha1 = "eb1e773abb056dcd8df2bfdf6af59b8b3a936565";
      };
    }

    {
      name = "fill-range-4.0.0.tgz";
      path = fetchurl {
        name = "fill-range-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fill-range/-/fill-range-4.0.0.tgz";
        sha1 = "d544811d428f98eb06a63dc402d2403c328c38f7";
      };
    }

    {
      name = "finalhandler-1.1.1.tgz";
      path = fetchurl {
        name = "finalhandler-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/finalhandler/-/finalhandler-1.1.1.tgz";
        sha1 = "eebf4ed840079c83f4249038c9d703008301b105";
      };
    }

    {
      name = "find-cache-dir-1.0.0.tgz";
      path = fetchurl {
        name = "find-cache-dir-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-1.0.0.tgz";
        sha1 = "9288e3e9e3cc3748717d39eade17cf71fc30ee6f";
      };
    }

    {
      name = "find-index-1.1.0.tgz";
      path = fetchurl {
        name = "find-index-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/find-index/-/find-index-1.1.0.tgz";
        sha1 = "53007c79cd30040d6816d79458e8837d5c5705ef";
      };
    }

    {
      name = "find-npm-prefix-1.0.2.tgz";
      path = fetchurl {
        name = "find-npm-prefix-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/find-npm-prefix/-/find-npm-prefix-1.0.2.tgz";
        sha1 = "8d8ce2c78b3b4b9e66c8acc6a37c231eb841cfdf";
      };
    }

    {
      name = "find-up-1.1.2.tgz";
      path = fetchurl {
        name = "find-up-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-1.1.2.tgz";
        sha1 = "6b2e9822b1a2ce0a60ab64d610eccad53cb24d0f";
      };
    }

    {
      name = "find-up-2.1.0.tgz";
      path = fetchurl {
        name = "find-up-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz";
        sha1 = "45d1b7e506c717ddd482775a2b77920a3c0c57a7";
      };
    }

    {
      name = "find-up-3.0.0.tgz";
      path = fetchurl {
        name = "find-up-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-3.0.0.tgz";
        sha1 = "49169f1d7993430646da61ecc5ae355c21c97b73";
      };
    }

    {
      name = "find-versions-2.0.0.tgz";
      path = fetchurl {
        name = "find-versions-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/find-versions/-/find-versions-2.0.0.tgz";
        sha1 = "2ad90d490f6828c1aa40292cf709ac3318210c3c";
      };
    }

    {
      name = "find-yarn-workspace-root-1.2.1.tgz";
      path = fetchurl {
        name = "find-yarn-workspace-root-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/find-yarn-workspace-root/-/find-yarn-workspace-root-1.2.1.tgz";
        sha1 = "40eb8e6e7c2502ddfaa2577c176f221422f860db";
      };
    }

    {
      name = "findup-sync-2.0.0.tgz";
      path = fetchurl {
        name = "findup-sync-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/findup-sync/-/findup-sync-2.0.0.tgz";
        sha1 = "9326b1488c22d1a6088650a86901b2d9a90a2cbc";
      };
    }

    {
      name = "fireworm-0.7.1.tgz";
      path = fetchurl {
        name = "fireworm-0.7.1.tgz";
        url  = "https://registry.yarnpkg.com/fireworm/-/fireworm-0.7.1.tgz";
        sha1 = "ccf20f7941f108883fcddb99383dbe6e1861c758";
      };
    }

    {
      name = "fixturify-project-1.5.3.tgz";
      path = fetchurl {
        name = "fixturify-project-1.5.3.tgz";
        url  = "https://registry.yarnpkg.com/fixturify-project/-/fixturify-project-1.5.3.tgz";
        sha1 = "2ba4ffec59c1d79ae6638f818c0847eb974d179b";
      };
    }

    {
      name = "fixturify-0.3.4.tgz";
      path = fetchurl {
        name = "fixturify-0.3.4.tgz";
        url  = "https://registry.yarnpkg.com/fixturify/-/fixturify-0.3.4.tgz";
        sha1 = "c676de404a7f8ee8e64d0b76118e62ec95ab7b25";
      };
    }

    {
      name = "flat-cache-1.3.0.tgz";
      path = fetchurl {
        name = "flat-cache-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/flat-cache/-/flat-cache-1.3.0.tgz";
        sha1 = "d3030b32b38154f4e3b7e9c709f490f7ef97c481";
      };
    }

    {
      name = "flat-4.1.0.tgz";
      path = fetchurl {
        name = "flat-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/flat/-/flat-4.1.0.tgz";
        sha1 = "090bec8b05e39cba309747f1d588f04dbaf98db2";
      };
    }

    {
      name = "flush-write-stream-1.0.3.tgz";
      path = fetchurl {
        name = "flush-write-stream-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/flush-write-stream/-/flush-write-stream-1.0.3.tgz";
        sha1 = "c5d586ef38af6097650b49bc41b55fabb19f35bd";
      };
    }

    {
      name = "follow-redirects-1.5.7.tgz";
      path = fetchurl {
        name = "follow-redirects-1.5.7.tgz";
        url  = "https://registry.yarnpkg.com/follow-redirects/-/follow-redirects-1.5.7.tgz";
        sha1 = "a39e4804dacb90202bca76a9e2ac10433ca6a69a";
      };
    }

    {
      name = "for-each-0.3.3.tgz";
      path = fetchurl {
        name = "for-each-0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz";
        sha1 = "69b447e88a0a5d32c3e7084f3f1710034b21376e";
      };
    }

    {
      name = "for-in-1.0.2.tgz";
      path = fetchurl {
        name = "for-in-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/for-in/-/for-in-1.0.2.tgz";
        sha1 = "81068d295a8142ec0ac726c6e2200c30fb6d5e80";
      };
    }

    {
      name = "for-own-0.1.5.tgz";
      path = fetchurl {
        name = "for-own-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/for-own/-/for-own-0.1.5.tgz";
        sha1 = "5265c681a4f294dabbf17c9509b6763aa84510ce";
      };
    }

    {
      name = "forever-agent-0.6.1.tgz";
      path = fetchurl {
        name = "forever-agent-0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/forever-agent/-/forever-agent-0.6.1.tgz";
        sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
      };
    }

    {
      name = "form-data-2.3.2.tgz";
      path = fetchurl {
        name = "form-data-2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/form-data/-/form-data-2.3.2.tgz";
        sha1 = "4970498be604c20c005d4f5c23aecd21d6b49099";
      };
    }

    {
      name = "formatio-1.2.0.tgz";
      path = fetchurl {
        name = "formatio-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/formatio/-/formatio-1.2.0.tgz";
        sha1 = "f3b2167d9068c4698a8d51f4f760a39a54d818eb";
      };
    }

    {
      name = "forwarded-0.1.2.tgz";
      path = fetchurl {
        name = "forwarded-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/forwarded/-/forwarded-0.1.2.tgz";
        sha1 = "98c23dab1175657b8c0573e8ceccd91b0ff18c84";
      };
    }

    {
      name = "fragment-cache-0.2.1.tgz";
      path = fetchurl {
        name = "fragment-cache-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/fragment-cache/-/fragment-cache-0.2.1.tgz";
        sha1 = "4290fad27f13e89be7f33799c6bc5a0abfff0d19";
      };
    }

    {
      name = "fresh-0.5.2.tgz";
      path = fetchurl {
        name = "fresh-0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/fresh/-/fresh-0.5.2.tgz";
        sha1 = "3d8cadd90d976569fa835ab1f8e4b23a105605a7";
      };
    }

    {
      name = "from2-1.3.0.tgz";
      path = fetchurl {
        name = "from2-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/from2/-/from2-1.3.0.tgz";
        sha1 = "88413baaa5f9a597cfde9221d86986cd3c061dfd";
      };
    }

    {
      name = "from2-2.3.0.tgz";
      path = fetchurl {
        name = "from2-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/from2/-/from2-2.3.0.tgz";
        sha1 = "8bfb5502bde4a4d36cfdeea007fcca21d7e382af";
      };
    }

    {
      name = "fs-extra-0.24.0.tgz";
      path = fetchurl {
        name = "fs-extra-0.24.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-0.24.0.tgz";
        sha1 = "d4e4342a96675cb7846633a6099249332b539952";
      };
    }

    {
      name = "fs-extra-0.30.0.tgz";
      path = fetchurl {
        name = "fs-extra-0.30.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-0.30.0.tgz";
        sha1 = "f233ffcc08d4da7d432daa449776989db1df93f0";
      };
    }

    {
      name = "fs-extra-1.0.0.tgz";
      path = fetchurl {
        name = "fs-extra-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-1.0.0.tgz";
        sha1 = "cd3ce5f7e7cb6145883fcae3191e9877f8587950";
      };
    }

    {
      name = "fs-extra-4.0.3.tgz";
      path = fetchurl {
        name = "fs-extra-4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-4.0.3.tgz";
        sha1 = "0d852122e5bc5beb453fb028e9c0c9bf36340c94";
      };
    }

    {
      name = "fs-extra-5.0.0.tgz";
      path = fetchurl {
        name = "fs-extra-5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-5.0.0.tgz";
        sha1 = "414d0110cdd06705734d055652c5411260c31abd";
      };
    }

    {
      name = "fs-extra-6.0.1.tgz";
      path = fetchurl {
        name = "fs-extra-6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-6.0.1.tgz";
        sha1 = "8abc128f7946e310135ddc93b98bddb410e7a34b";
      };
    }

    {
      name = "fs-extra-7.0.0.tgz";
      path = fetchurl {
        name = "fs-extra-7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-7.0.0.tgz";
        sha1 = "8cc3f47ce07ef7b3593a11b9fb245f7e34c041d6";
      };
    }

    {
      name = "fs-minipass-1.2.5.tgz";
      path = fetchurl {
        name = "fs-minipass-1.2.5.tgz";
        url  = "https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-1.2.5.tgz";
        sha1 = "06c277218454ec288df77ada54a03b8702aacb9d";
      };
    }

    {
      name = "fs-tree-diff-0.5.9.tgz";
      path = fetchurl {
        name = "fs-tree-diff-0.5.9.tgz";
        url  = "https://registry.yarnpkg.com/fs-tree-diff/-/fs-tree-diff-0.5.9.tgz";
        sha1 = "a4ec6182c2f5bd80b9b83c8e23e4522e6f5fd946";
      };
    }

    {
      name = "fs-updater-1.0.4.tgz";
      path = fetchurl {
        name = "fs-updater-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/fs-updater/-/fs-updater-1.0.4.tgz";
        sha1 = "2329980f99ae9176e9a0e84f7637538a182ce63b";
      };
    }

    {
      name = "fs-vacuum-1.2.10.tgz";
      path = fetchurl {
        name = "fs-vacuum-1.2.10.tgz";
        url  = "https://registry.yarnpkg.com/fs-vacuum/-/fs-vacuum-1.2.10.tgz";
        sha1 = "b7629bec07a4031a2548fdf99f5ecf1cc8b31e36";
      };
    }

    {
      name = "fs-write-stream-atomic-1.0.10.tgz";
      path = fetchurl {
        name = "fs-write-stream-atomic-1.0.10.tgz";
        url  = "https://registry.yarnpkg.com/fs-write-stream-atomic/-/fs-write-stream-atomic-1.0.10.tgz";
        sha1 = "b47df53493ef911df75731e70a9ded0189db40c9";
      };
    }

    {
      name = "fs.realpath-1.0.0.tgz";
      path = fetchurl {
        name = "fs.realpath-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz";
        sha1 = "1504ad2523158caa40db4a2787cb01411994ea4f";
      };
    }

    {
      name = "fsevents-1.2.4.tgz";
      path = fetchurl {
        name = "fsevents-1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/fsevents/-/fsevents-1.2.4.tgz";
        sha1 = "f41dcb1af2582af3692da36fc55cbd8e1041c426";
      };
    }

    {
      name = "fstream-1.0.11.tgz";
      path = fetchurl {
        name = "fstream-1.0.11.tgz";
        url  = "https://registry.yarnpkg.com/fstream/-/fstream-1.0.11.tgz";
        sha1 = "5c1fb1f117477114f0632a0eb4b71b3cb0fd3171";
      };
    }

    {
      name = "function-bind-1.1.1.tgz";
      path = fetchurl {
        name = "function-bind-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz";
        sha1 = "a56899d3ea3c9bab874bb9773b7c5ede92f4895d";
      };
    }

    {
      name = "functional-red-black-tree-1.0.1.tgz";
      path = fetchurl {
        name = "functional-red-black-tree-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz";
        sha1 = "1b0ab3bd553b2a0d6399d29c0e3ea0b252078327";
      };
    }

    {
      name = "gauge-2.7.4.tgz";
      path = fetchurl {
        name = "gauge-2.7.4.tgz";
        url  = "https://registry.yarnpkg.com/gauge/-/gauge-2.7.4.tgz";
        sha1 = "2c03405c7538c39d7eb37b317022e325fb018bf7";
      };
    }

    {
      name = "gaze-1.1.3.tgz";
      path = fetchurl {
        name = "gaze-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/gaze/-/gaze-1.1.3.tgz";
        sha1 = "c441733e13b927ac8c0ff0b4c3b033f28812924a";
      };
    }

    {
      name = "genfun-4.0.1.tgz";
      path = fetchurl {
        name = "genfun-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/genfun/-/genfun-4.0.1.tgz";
        sha1 = "ed10041f2e4a7f1b0a38466d17a5c3e27df1dfc1";
      };
    }

    {
      name = "gentle-fs-2.0.1.tgz";
      path = fetchurl {
        name = "gentle-fs-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/gentle-fs/-/gentle-fs-2.0.1.tgz";
        sha1 = "585cfd612bfc5cd52471fdb42537f016a5ce3687";
      };
    }

    {
      name = "get-caller-file-1.0.3.tgz";
      path = fetchurl {
        name = "get-caller-file-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-1.0.3.tgz";
        sha1 = "f978fa4c90d1dfe7ff2d6beda2a515e713bdcf4a";
      };
    }

    {
      name = "get-stdin-4.0.1.tgz";
      path = fetchurl {
        name = "get-stdin-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/get-stdin/-/get-stdin-4.0.1.tgz";
        sha1 = "b968c6b0a04384324902e8bf1a5df32579a450fe";
      };
    }

    {
      name = "get-stdin-5.0.1.tgz";
      path = fetchurl {
        name = "get-stdin-5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/get-stdin/-/get-stdin-5.0.1.tgz";
        sha1 = "122e161591e21ff4c52530305693f20e6393a398";
      };
    }

    {
      name = "get-stream-2.3.1.tgz";
      path = fetchurl {
        name = "get-stream-2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-2.3.1.tgz";
        sha1 = "5f38f93f346009666ee0150a054167f91bdd95de";
      };
    }

    {
      name = "get-stream-3.0.0.tgz";
      path = fetchurl {
        name = "get-stream-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-3.0.0.tgz";
        sha1 = "8e943d1358dc37555054ecbe2edb05aa174ede14";
      };
    }

    {
      name = "get-stream-4.0.0.tgz";
      path = fetchurl {
        name = "get-stream-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-4.0.0.tgz";
        sha1 = "9e074cb898bd2b9ebabb445a1766d7f43576d977";
      };
    }

    {
      name = "get-value-2.0.6.tgz";
      path = fetchurl {
        name = "get-value-2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/get-value/-/get-value-2.0.6.tgz";
        sha1 = "dc15ca1c672387ca76bd37ac0a395ba2042a2c28";
      };
    }

    {
      name = "getpass-0.1.7.tgz";
      path = fetchurl {
        name = "getpass-0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/getpass/-/getpass-0.1.7.tgz";
        sha1 = "5eff8e3e684d569ae4cb2b1282604e8ba62149fa";
      };
    }

    {
      name = "git-log-parser-1.2.0.tgz";
      path = fetchurl {
        name = "git-log-parser-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/git-log-parser/-/git-log-parser-1.2.0.tgz";
        sha1 = "2e6a4c1b13fc00028207ba795a7ac31667b9fd4a";
      };
    }

    {
      name = "git-repo-info-2.0.0.tgz";
      path = fetchurl {
        name = "git-repo-info-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/git-repo-info/-/git-repo-info-2.0.0.tgz";
        sha1 = "2e7a68ba3d0253e8e885c4138f922e6561de59bb";
      };
    }

    {
      name = "git-up-2.0.10.tgz";
      path = fetchurl {
        name = "git-up-2.0.10.tgz";
        url  = "https://registry.yarnpkg.com/git-up/-/git-up-2.0.10.tgz";
        sha1 = "20fe6bafbef4384cae253dc4f463c49a0c3bd2ec";
      };
    }

    {
      name = "git-url-parse-10.0.1.tgz";
      path = fetchurl {
        name = "git-url-parse-10.0.1.tgz";
        url  = "https://registry.yarnpkg.com/git-url-parse/-/git-url-parse-10.0.1.tgz";
        sha1 = "75f153b24ac7297447fc583cf9fac23a5ae687c1";
      };
    }

    {
      name = "glob-base-0.3.0.tgz";
      path = fetchurl {
        name = "glob-base-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/glob-base/-/glob-base-0.3.0.tgz";
        sha1 = "dbb164f6221b1c0b1ccf82aea328b497df0ea3c4";
      };
    }

    {
      name = "glob-parent-2.0.0.tgz";
      path = fetchurl {
        name = "glob-parent-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/glob-parent/-/glob-parent-2.0.0.tgz";
        sha1 = "81383d72db054fcccf5336daa902f182f6edbb28";
      };
    }

    {
      name = "glob-parent-3.1.0.tgz";
      path = fetchurl {
        name = "glob-parent-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/glob-parent/-/glob-parent-3.1.0.tgz";
        sha1 = "9e6af6299d8d3bd2bd40430832bd113df906c5ae";
      };
    }

    {
      name = "glob-to-regexp-0.3.0.tgz";
      path = fetchurl {
        name = "glob-to-regexp-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/glob-to-regexp/-/glob-to-regexp-0.3.0.tgz";
        sha1 = "8c5a1494d2066c570cc3bfe4496175acc4d502ab";
      };
    }

    {
      name = "glob-3.2.3.tgz";
      path = fetchurl {
        name = "glob-3.2.3.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-3.2.3.tgz";
        sha1 = "e313eeb249c7affaa5c475286b0e115b59839467";
      };
    }

    {
      name = "glob-5.0.15.tgz";
      path = fetchurl {
        name = "glob-5.0.15.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-5.0.15.tgz";
        sha1 = "1bc936b9e02f4a603fcc222ecf7633d30b8b93b1";
      };
    }

    {
      name = "glob-7.1.3.tgz";
      path = fetchurl {
        name = "glob-7.1.3.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.1.3.tgz";
        sha1 = "3960832d3f1574108342dafd3a67b332c0969df1";
      };
    }

    {
      name = "glob-7.0.6.tgz";
      path = fetchurl {
        name = "glob-7.0.6.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.0.6.tgz";
        sha1 = "211bafaf49e525b8cd93260d14ab136152b3f57a";
      };
    }

    {
      name = "global-dirs-0.1.1.tgz";
      path = fetchurl {
        name = "global-dirs-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/global-dirs/-/global-dirs-0.1.1.tgz";
        sha1 = "b319c0dd4607f353f3be9cca4c72fc148c49f445";
      };
    }

    {
      name = "global-modules-1.0.0.tgz";
      path = fetchurl {
        name = "global-modules-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/global-modules/-/global-modules-1.0.0.tgz";
        sha1 = "6d770f0eb523ac78164d72b5e71a8877265cc3ea";
      };
    }

    {
      name = "global-prefix-1.0.2.tgz";
      path = fetchurl {
        name = "global-prefix-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/global-prefix/-/global-prefix-1.0.2.tgz";
        sha1 = "dbf743c6c14992593c655568cb66ed32c0122ebe";
      };
    }

    {
      name = "global-4.3.2.tgz";
      path = fetchurl {
        name = "global-4.3.2.tgz";
        url  = "https://registry.yarnpkg.com/global/-/global-4.3.2.tgz";
        sha1 = "e76989268a6c74c38908b1305b10fc0e394e9d0f";
      };
    }

    {
      name = "globals-11.7.0.tgz";
      path = fetchurl {
        name = "globals-11.7.0.tgz";
        url  = "https://registry.yarnpkg.com/globals/-/globals-11.7.0.tgz";
        sha1 = "a583faa43055b1aca771914bf68258e2fc125673";
      };
    }

    {
      name = "globals-9.18.0.tgz";
      path = fetchurl {
        name = "globals-9.18.0.tgz";
        url  = "https://registry.yarnpkg.com/globals/-/globals-9.18.0.tgz";
        sha1 = "aa3896b3e69b487f17e31ed2143d69a8e30c2d8a";
      };
    }

    {
      name = "globby-5.0.0.tgz";
      path = fetchurl {
        name = "globby-5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/globby/-/globby-5.0.0.tgz";
        sha1 = "ebd84667ca0dbb330b99bcfc68eac2bc54370e0d";
      };
    }

    {
      name = "globby-8.0.1.tgz";
      path = fetchurl {
        name = "globby-8.0.1.tgz";
        url  = "https://registry.yarnpkg.com/globby/-/globby-8.0.1.tgz";
        sha1 = "b5ad48b8aa80b35b814fc1281ecc851f1d2b5b50";
      };
    }

    {
      name = "globule-1.2.1.tgz";
      path = fetchurl {
        name = "globule-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/globule/-/globule-1.2.1.tgz";
        sha1 = "5dffb1b191f22d20797a9369b49eab4e9839696d";
      };
    }

    {
      name = "good-listener-1.2.2.tgz";
      path = fetchurl {
        name = "good-listener-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/good-listener/-/good-listener-1.2.2.tgz";
        sha1 = "d53b30cdf9313dffb7dc9a0d477096aa6d145c50";
      };
    }

    {
      name = "got-6.7.1.tgz";
      path = fetchurl {
        name = "got-6.7.1.tgz";
        url  = "http://registry.npmjs.org/got/-/got-6.7.1.tgz";
        sha1 = "240cd05785a9a18e561dc1b44b41c763ef1e8db0";
      };
    }

    {
      name = "graceful-fs-4.1.11.tgz";
      path = fetchurl {
        name = "graceful-fs-4.1.11.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.1.11.tgz";
        sha1 = "0e8bdfe4d1ddb8854d64e04ea7c00e2a026e5658";
      };
    }

    {
      name = "graceful-fs-2.0.3.tgz";
      path = fetchurl {
        name = "graceful-fs-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-2.0.3.tgz";
        sha1 = "7cd2cdb228a4a3f36e95efa6cc142de7d1a136d0";
      };
    }

    {
      name = "graceful-readlink-1.0.1.tgz";
      path = fetchurl {
        name = "graceful-readlink-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
        sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
      };
    }

    {
      name = "growl-1.7.0.tgz";
      path = fetchurl {
        name = "growl-1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/growl/-/growl-1.7.0.tgz";
        sha1 = "de2d66136d002e112ba70f3f10c31cf7c350b2da";
      };
    }

    {
      name = "growly-1.3.0.tgz";
      path = fetchurl {
        name = "growly-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/growly/-/growly-1.3.0.tgz";
        sha1 = "f10748cbe76af964b7c96c93c6bcc28af120c081";
      };
    }

    {
      name = "handlebars-4.0.12.tgz";
      path = fetchurl {
        name = "handlebars-4.0.12.tgz";
        url  = "https://registry.yarnpkg.com/handlebars/-/handlebars-4.0.12.tgz";
        sha1 = "2c15c8a96d46da5e266700518ba8cb8d919d5bc5";
      };
    }

    {
      name = "har-schema-2.0.0.tgz";
      path = fetchurl {
        name = "har-schema-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/har-schema/-/har-schema-2.0.0.tgz";
        sha1 = "a94c2224ebcac04782a0d9035521f24735b7ec92";
      };
    }

    {
      name = "har-validator-5.0.3.tgz";
      path = fetchurl {
        name = "har-validator-5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/har-validator/-/har-validator-5.0.3.tgz";
        sha1 = "ba402c266194f15956ef15e0fcf242993f6a7dfd";
      };
    }

    {
      name = "har-validator-5.1.0.tgz";
      path = fetchurl {
        name = "har-validator-5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/har-validator/-/har-validator-5.1.0.tgz";
        sha1 = "44657f5688a22cfd4b72486e81b3a3fb11742c29";
      };
    }

    {
      name = "harmony-reflect-1.6.0.tgz";
      path = fetchurl {
        name = "harmony-reflect-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/harmony-reflect/-/harmony-reflect-1.6.0.tgz";
        sha1 = "9c28a77386ec225f7b5d370f9861ba09c4eea58f";
      };
    }

    {
      name = "has-ansi-2.0.0.tgz";
      path = fetchurl {
        name = "has-ansi-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-ansi/-/has-ansi-2.0.0.tgz";
        sha1 = "34f5049ce1ecdf2b0649af3ef24e45ed35416d91";
      };
    }

    {
      name = "has-binary2-1.0.3.tgz";
      path = fetchurl {
        name = "has-binary2-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/has-binary2/-/has-binary2-1.0.3.tgz";
        sha1 = "7776ac627f3ea77250cfc332dab7ddf5e4f5d11d";
      };
    }

    {
      name = "has-color-0.1.7.tgz";
      path = fetchurl {
        name = "has-color-0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/has-color/-/has-color-0.1.7.tgz";
        sha1 = "67144a5260c34fc3cca677d041daf52fe7b78b2f";
      };
    }

    {
      name = "has-cors-1.1.0.tgz";
      path = fetchurl {
        name = "has-cors-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/has-cors/-/has-cors-1.1.0.tgz";
        sha1 = "5e474793f7ea9843d1bb99c23eef49ff126fff39";
      };
    }

    {
      name = "has-flag-2.0.0.tgz";
      path = fetchurl {
        name = "has-flag-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-flag/-/has-flag-2.0.0.tgz";
        sha1 = "e8207af1cc7b30d446cc70b734b5e8be18f88d51";
      };
    }

    {
      name = "has-flag-3.0.0.tgz";
      path = fetchurl {
        name = "has-flag-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz";
        sha1 = "b5d454dc2199ae225699f3467e5a07f3b955bafd";
      };
    }

    {
      name = "has-unicode-2.0.1.tgz";
      path = fetchurl {
        name = "has-unicode-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/has-unicode/-/has-unicode-2.0.1.tgz";
        sha1 = "e0e6fe6a28cf51138855e086d1691e771de2a8b9";
      };
    }

    {
      name = "has-value-0.3.1.tgz";
      path = fetchurl {
        name = "has-value-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/has-value/-/has-value-0.3.1.tgz";
        sha1 = "7b1f58bada62ca827ec0a2078025654845995e1f";
      };
    }

    {
      name = "has-value-1.0.0.tgz";
      path = fetchurl {
        name = "has-value-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-value/-/has-value-1.0.0.tgz";
        sha1 = "18b281da585b1c5c51def24c930ed29a0be6b177";
      };
    }

    {
      name = "has-values-0.1.4.tgz";
      path = fetchurl {
        name = "has-values-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/has-values/-/has-values-0.1.4.tgz";
        sha1 = "6d61de95d91dfca9b9a02089ad384bff8f62b771";
      };
    }

    {
      name = "has-values-1.0.0.tgz";
      path = fetchurl {
        name = "has-values-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-values/-/has-values-1.0.0.tgz";
        sha1 = "95b0b63fec2146619a6fe57fe75628d5a39efe4f";
      };
    }

    {
      name = "has-1.0.3.tgz";
      path = fetchurl {
        name = "has-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/has/-/has-1.0.3.tgz";
        sha1 = "722d7cbfc1f6aa8241f16dd814e011e1f41e8796";
      };
    }

    {
      name = "hash-base-3.0.4.tgz";
      path = fetchurl {
        name = "hash-base-3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/hash-base/-/hash-base-3.0.4.tgz";
        sha1 = "5fc8686847ecd73499403319a6b0a3f3f6ae4918";
      };
    }

    {
      name = "hash-for-dep-1.2.3.tgz";
      path = fetchurl {
        name = "hash-for-dep-1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/hash-for-dep/-/hash-for-dep-1.2.3.tgz";
        sha1 = "5ec69fca32c23523972d52acb5bb65ffc3664cab";
      };
    }

    {
      name = "hash.js-1.1.5.tgz";
      path = fetchurl {
        name = "hash.js-1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/hash.js/-/hash.js-1.1.5.tgz";
        sha1 = "e38ab4b85dfb1e0c40fe9265c0e9b54854c23812";
      };
    }

    {
      name = "hasha-2.2.0.tgz";
      path = fetchurl {
        name = "hasha-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/hasha/-/hasha-2.2.0.tgz";
        sha1 = "78d7cbfc1e6d66303fe79837365984517b2f6ee1";
      };
    }

    {
      name = "heimdalljs-fs-monitor-0.2.2.tgz";
      path = fetchurl {
        name = "heimdalljs-fs-monitor-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/heimdalljs-fs-monitor/-/heimdalljs-fs-monitor-0.2.2.tgz";
        sha1 = "a76d98f52dbf3aa1b7c20cebb0132e2f5eeb9204";
      };
    }

    {
      name = "heimdalljs-graph-0.3.5.tgz";
      path = fetchurl {
        name = "heimdalljs-graph-0.3.5.tgz";
        url  = "https://registry.yarnpkg.com/heimdalljs-graph/-/heimdalljs-graph-0.3.5.tgz";
        sha1 = "420fbbc8fc3aec5963ddbbf1a5fb47921c4a5927";
      };
    }

    {
      name = "heimdalljs-logger-0.1.10.tgz";
      path = fetchurl {
        name = "heimdalljs-logger-0.1.10.tgz";
        url  = "https://registry.yarnpkg.com/heimdalljs-logger/-/heimdalljs-logger-0.1.10.tgz";
        sha1 = "90cad58aabb1590a3c7e640ddc6a4cd3a43faaf7";
      };
    }

    {
      name = "heimdalljs-0.2.6.tgz";
      path = fetchurl {
        name = "heimdalljs-0.2.6.tgz";
        url  = "https://registry.yarnpkg.com/heimdalljs/-/heimdalljs-0.2.6.tgz";
        sha1 = "b0eebabc412813aeb9542f9cc622cb58dbdcd9fe";
      };
    }

    {
      name = "heimdalljs-0.3.3.tgz";
      path = fetchurl {
        name = "heimdalljs-0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/heimdalljs/-/heimdalljs-0.3.3.tgz";
        sha1 = "e92d2c6f77fd46d5bf50b610d28ad31755054d0b";
      };
    }

    {
      name = "hmac-drbg-1.0.1.tgz";
      path = fetchurl {
        name = "hmac-drbg-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/hmac-drbg/-/hmac-drbg-1.0.1.tgz";
        sha1 = "d2745701025a6c775a6c545793ed502fc0c649a1";
      };
    }

    {
      name = "home-or-tmp-2.0.0.tgz";
      path = fetchurl {
        name = "home-or-tmp-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/home-or-tmp/-/home-or-tmp-2.0.0.tgz";
        sha1 = "e36c3f2d2cae7d746a857e38d18d5f32a7882db8";
      };
    }

    {
      name = "homedir-polyfill-1.0.1.tgz";
      path = fetchurl {
        name = "homedir-polyfill-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/homedir-polyfill/-/homedir-polyfill-1.0.1.tgz";
        sha1 = "4c2bbc8a758998feebf5ed68580f76d46768b4bc";
      };
    }

    {
      name = "hook-std-1.1.0.tgz";
      path = fetchurl {
        name = "hook-std-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/hook-std/-/hook-std-1.1.0.tgz";
        sha1 = "7f76b74b6f96d3cd4106afb50a66bdb0af2d2a2d";
      };
    }

    {
      name = "hosted-git-info-2.7.1.tgz";
      path = fetchurl {
        name = "hosted-git-info-2.7.1.tgz";
        url  = "https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.7.1.tgz";
        sha1 = "97f236977bd6e125408930ff6de3eec6281ec047";
      };
    }

    {
      name = "html-encoding-sniffer-1.0.2.tgz";
      path = fetchurl {
        name = "html-encoding-sniffer-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/html-encoding-sniffer/-/html-encoding-sniffer-1.0.2.tgz";
        sha1 = "e70d84b94da53aa375e11fe3a351be6642ca46f8";
      };
    }

    {
      name = "htmlparser2-3.8.3.tgz";
      path = fetchurl {
        name = "htmlparser2-3.8.3.tgz";
        url  = "https://registry.yarnpkg.com/htmlparser2/-/htmlparser2-3.8.3.tgz";
        sha1 = "996c28b191516a8be86501a7d79757e5c70c1068";
      };
    }

    {
      name = "http-cache-semantics-3.8.1.tgz";
      path = fetchurl {
        name = "http-cache-semantics-3.8.1.tgz";
        url  = "https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-3.8.1.tgz";
        sha1 = "39b0e16add9b605bf0a9ef3d9daaf4843b4cacd2";
      };
    }

    {
      name = "http-errors-1.6.2.tgz";
      path = fetchurl {
        name = "http-errors-1.6.2.tgz";
        url  = "https://registry.yarnpkg.com/http-errors/-/http-errors-1.6.2.tgz";
        sha1 = "0a002cc85707192a7e7946ceedc11155f60ec736";
      };
    }

    {
      name = "http-errors-1.6.3.tgz";
      path = fetchurl {
        name = "http-errors-1.6.3.tgz";
        url  = "http://registry.npmjs.org/http-errors/-/http-errors-1.6.3.tgz";
        sha1 = "8b55680bb4be283a0b5bf4ea2e38580be1d9320d";
      };
    }

    {
      name = "http-parser-js-0.4.13.tgz";
      path = fetchurl {
        name = "http-parser-js-0.4.13.tgz";
        url  = "https://registry.yarnpkg.com/http-parser-js/-/http-parser-js-0.4.13.tgz";
        sha1 = "3bd6d6fde6e3172c9334c3b33b6c193d80fe1137";
      };
    }

    {
      name = "http-proxy-agent-2.1.0.tgz";
      path = fetchurl {
        name = "http-proxy-agent-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-2.1.0.tgz";
        sha1 = "e4821beef5b2142a2026bd73926fe537631c5405";
      };
    }

    {
      name = "http-proxy-1.17.0.tgz";
      path = fetchurl {
        name = "http-proxy-1.17.0.tgz";
        url  = "https://registry.yarnpkg.com/http-proxy/-/http-proxy-1.17.0.tgz";
        sha1 = "7ad38494658f84605e2f6db4436df410f4e5be9a";
      };
    }

    {
      name = "http-signature-1.2.0.tgz";
      path = fetchurl {
        name = "http-signature-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/http-signature/-/http-signature-1.2.0.tgz";
        sha1 = "9aecd925114772f3d95b65a60abb8f7c18fbace1";
      };
    }

    {
      name = "https-browserify-1.0.0.tgz";
      path = fetchurl {
        name = "https-browserify-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/https-browserify/-/https-browserify-1.0.0.tgz";
        sha1 = "ec06c10e0a34c0f2faf199f7fd7fc78fffd03c73";
      };
    }

    {
      name = "https-proxy-agent-2.2.1.tgz";
      path = fetchurl {
        name = "https-proxy-agent-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-2.2.1.tgz";
        sha1 = "51552970fa04d723e04c56d04178c3f92592bbc0";
      };
    }

    {
      name = "humanize-ms-1.2.1.tgz";
      path = fetchurl {
        name = "humanize-ms-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/humanize-ms/-/humanize-ms-1.2.1.tgz";
        sha1 = "c46e3159a293f6b896da29316d8b6fe8bb79bbed";
      };
    }

    {
      name = "iconv-lite-0.4.19.tgz";
      path = fetchurl {
        name = "iconv-lite-0.4.19.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.19.tgz";
        sha1 = "f7468f60135f5e5dad3399c0a81be9a1603a082b";
      };
    }

    {
      name = "iconv-lite-0.4.23.tgz";
      path = fetchurl {
        name = "iconv-lite-0.4.23.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.23.tgz";
        sha1 = "297871f63be507adcfbfca715d0cd0eed84e9a63";
      };
    }

    {
      name = "iconv-lite-0.4.24.tgz";
      path = fetchurl {
        name = "iconv-lite-0.4.24.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz";
        sha1 = "2022b4b25fbddc21d2f524974a474aafe733908b";
      };
    }

    {
      name = "ieee754-1.1.12.tgz";
      path = fetchurl {
        name = "ieee754-1.1.12.tgz";
        url  = "https://registry.yarnpkg.com/ieee754/-/ieee754-1.1.12.tgz";
        sha1 = "50bf24e5b9c8bb98af4964c941cdb0918da7b60b";
      };
    }

    {
      name = "iferr-0.1.5.tgz";
      path = fetchurl {
        name = "iferr-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/iferr/-/iferr-0.1.5.tgz";
        sha1 = "c60eed69e6d8fdb6b3104a1fcbca1c192dc5b501";
      };
    }

    {
      name = "iferr-1.0.2.tgz";
      path = fetchurl {
        name = "iferr-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/iferr/-/iferr-1.0.2.tgz";
        sha1 = "e9fde49a9da06dc4a4194c6c9ed6d08305037a6d";
      };
    }

    {
      name = "ignore-walk-3.0.1.tgz";
      path = fetchurl {
        name = "ignore-walk-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ignore-walk/-/ignore-walk-3.0.1.tgz";
        sha1 = "a83e62e7d272ac0e3b551aaa82831a19b69f82f8";
      };
    }

    {
      name = "ignore-3.3.10.tgz";
      path = fetchurl {
        name = "ignore-3.3.10.tgz";
        url  = "https://registry.yarnpkg.com/ignore/-/ignore-3.3.10.tgz";
        sha1 = "0a97fb876986e8081c631160f8f9f389157f0043";
      };
    }

    {
      name = "image-size-0.4.0.tgz";
      path = fetchurl {
        name = "image-size-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/image-size/-/image-size-0.4.0.tgz";
        sha1 = "d4b4e1f61952e4cbc1cea9a6b0c915fecb707510";
      };
    }

    {
      name = "image-size-0.5.5.tgz";
      path = fetchurl {
        name = "image-size-0.5.5.tgz";
        url  = "https://registry.yarnpkg.com/image-size/-/image-size-0.5.5.tgz";
        sha1 = "09dfd4ab9d20e29eb1c3e80b8990378df9e3cb9c";
      };
    }

    {
      name = "import-from-2.1.0.tgz";
      path = fetchurl {
        name = "import-from-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/import-from/-/import-from-2.1.0.tgz";
        sha1 = "335db7f2a7affd53aaa471d4b8021dee36b7f3b1";
      };
    }

    {
      name = "import-lazy-2.1.0.tgz";
      path = fetchurl {
        name = "import-lazy-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/import-lazy/-/import-lazy-2.1.0.tgz";
        sha1 = "05698e3d45c88e8d7e9d92cb0584e77f096f3e43";
      };
    }

    {
      name = "imurmurhash-0.1.4.tgz";
      path = fetchurl {
        name = "imurmurhash-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz";
        sha1 = "9218b9b2b928a238b13dc4fb6b6d576f231453ea";
      };
    }

    {
      name = "in-publish-2.0.0.tgz";
      path = fetchurl {
        name = "in-publish-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/in-publish/-/in-publish-2.0.0.tgz";
        sha1 = "e20ff5e3a2afc2690320b6dc552682a9c7fadf51";
      };
    }

    {
      name = "include-path-searcher-0.1.0.tgz";
      path = fetchurl {
        name = "include-path-searcher-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/include-path-searcher/-/include-path-searcher-0.1.0.tgz";
        sha1 = "c0cf2ddfa164fb2eae07bc7ca43a7f191cb4d7bd";
      };
    }

    {
      name = "indent-string-2.1.0.tgz";
      path = fetchurl {
        name = "indent-string-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/indent-string/-/indent-string-2.1.0.tgz";
        sha1 = "8e2d48348742121b4a8218b7a137e9a52049dc80";
      };
    }

    {
      name = "indent-string-3.2.0.tgz";
      path = fetchurl {
        name = "indent-string-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/indent-string/-/indent-string-3.2.0.tgz";
        sha1 = "4a5fd6d27cc332f37e5419a504dbb837105c9289";
      };
    }

    {
      name = "indexof-0.0.1.tgz";
      path = fetchurl {
        name = "indexof-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/indexof/-/indexof-0.0.1.tgz";
        sha1 = "82dc336d232b9062179d05ab3293a66059fd435d";
      };
    }

    {
      name = "inflection-1.12.0.tgz";
      path = fetchurl {
        name = "inflection-1.12.0.tgz";
        url  = "https://registry.yarnpkg.com/inflection/-/inflection-1.12.0.tgz";
        sha1 = "a200935656d6f5f6bc4dc7502e1aecb703228416";
      };
    }

    {
      name = "inflight-1.0.6.tgz";
      path = fetchurl {
        name = "inflight-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz";
        sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
      };
    }

    {
      name = "inherits-2.0.3.tgz";
      path = fetchurl {
        name = "inherits-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.3.tgz";
        sha1 = "633c2c83e3da42a502f52466022480f4208261de";
      };
    }

    {
      name = "inherits-2.0.1.tgz";
      path = fetchurl {
        name = "inherits-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      };
    }

    {
      name = "ini-1.3.5.tgz";
      path = fetchurl {
        name = "ini-1.3.5.tgz";
        url  = "https://registry.yarnpkg.com/ini/-/ini-1.3.5.tgz";
        sha1 = "eee25f56db1c9ec6085e0c22778083f596abf927";
      };
    }

    {
      name = "init-package-json-1.10.3.tgz";
      path = fetchurl {
        name = "init-package-json-1.10.3.tgz";
        url  = "https://registry.yarnpkg.com/init-package-json/-/init-package-json-1.10.3.tgz";
        sha1 = "45ffe2f610a8ca134f2bd1db5637b235070f6cbe";
      };
    }

    {
      name = "inline-source-map-comment-1.0.5.tgz";
      path = fetchurl {
        name = "inline-source-map-comment-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/inline-source-map-comment/-/inline-source-map-comment-1.0.5.tgz";
        sha1 = "50a8a44c2a790dfac441b5c94eccd5462635faf6";
      };
    }

    {
      name = "inquirer-2.0.0.tgz";
      path = fetchurl {
        name = "inquirer-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/inquirer/-/inquirer-2.0.0.tgz";
        sha1 = "e1351687b90d150ca403ceaa3cefb1e3065bef4b";
      };
    }

    {
      name = "inquirer-3.3.0.tgz";
      path = fetchurl {
        name = "inquirer-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/inquirer/-/inquirer-3.3.0.tgz";
        sha1 = "9dd2f2ad765dcab1ff0443b491442a20ba227dc9";
      };
    }

    {
      name = "into-stream-3.1.0.tgz";
      path = fetchurl {
        name = "into-stream-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/into-stream/-/into-stream-3.1.0.tgz";
        sha1 = "96fb0a936c12babd6ff1752a17d05616abd094c6";
      };
    }

    {
      name = "invariant-2.2.4.tgz";
      path = fetchurl {
        name = "invariant-2.2.4.tgz";
        url  = "https://registry.yarnpkg.com/invariant/-/invariant-2.2.4.tgz";
        sha1 = "610f3c92c9359ce1db616e538008d23ff35158e6";
      };
    }

    {
      name = "invert-kv-1.0.0.tgz";
      path = fetchurl {
        name = "invert-kv-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/invert-kv/-/invert-kv-1.0.0.tgz";
        sha1 = "104a8e4aaca6d3d8cd157a8ef8bfab2d7a3ffdb6";
      };
    }

    {
      name = "invert-kv-2.0.0.tgz";
      path = fetchurl {
        name = "invert-kv-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/invert-kv/-/invert-kv-2.0.0.tgz";
        sha1 = "7393f5afa59ec9ff5f67a27620d11c226e3eec02";
      };
    }

    {
      name = "ip-regex-1.0.3.tgz";
      path = fetchurl {
        name = "ip-regex-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/ip-regex/-/ip-regex-1.0.3.tgz";
        sha1 = "dc589076f659f419c222039a33316f1c7387effd";
      };
    }

    {
      name = "ip-regex-2.1.0.tgz";
      path = fetchurl {
        name = "ip-regex-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ip-regex/-/ip-regex-2.1.0.tgz";
        sha1 = "fa78bf5d2e6913c911ce9f819ee5146bb6d844e9";
      };
    }

    {
      name = "ip-1.1.5.tgz";
      path = fetchurl {
        name = "ip-1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/ip/-/ip-1.1.5.tgz";
        sha1 = "bdded70114290828c0a039e72ef25f5aaec4354a";
      };
    }

    {
      name = "ipaddr.js-1.8.0.tgz";
      path = fetchurl {
        name = "ipaddr.js-1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/ipaddr.js/-/ipaddr.js-1.8.0.tgz";
        sha1 = "eaa33d6ddd7ace8f7f6fe0c9ca0440e706738b1e";
      };
    }

    {
      name = "is-accessor-descriptor-0.1.6.tgz";
      path = fetchurl {
        name = "is-accessor-descriptor-0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz";
        sha1 = "a9e12cb3ae8d876727eeef3843f8a0897b5c98d6";
      };
    }

    {
      name = "is-accessor-descriptor-1.0.0.tgz";
      path = fetchurl {
        name = "is-accessor-descriptor-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz";
        sha1 = "169c2f6d3df1f992618072365c9b0ea1f6878656";
      };
    }

    {
      name = "is-arrayish-0.2.1.tgz";
      path = fetchurl {
        name = "is-arrayish-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz";
        sha1 = "77c99840527aa8ecb1a8ba697b80645a7a926a9d";
      };
    }

    {
      name = "is-arrayish-0.3.2.tgz";
      path = fetchurl {
        name = "is-arrayish-0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.3.2.tgz";
        sha1 = "4574a2ae56f7ab206896fb431eaeed066fdf8f03";
      };
    }

    {
      name = "is-binary-path-1.0.1.tgz";
      path = fetchurl {
        name = "is-binary-path-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-1.0.1.tgz";
        sha1 = "75f16642b480f187a711c814161fd3a4a7655898";
      };
    }

    {
      name = "is-buffer-1.1.6.tgz";
      path = fetchurl {
        name = "is-buffer-1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz";
        sha1 = "efaa2ea9daa0d7ab2ea13a97b2b8ad51fefbe8be";
      };
    }

    {
      name = "is-buffer-2.0.3.tgz";
      path = fetchurl {
        name = "is-buffer-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/is-buffer/-/is-buffer-2.0.3.tgz";
        sha1 = "4ecf3fcf749cbd1e472689e109ac66261a25e725";
      };
    }

    {
      name = "is-builtin-module-1.0.0.tgz";
      path = fetchurl {
        name = "is-builtin-module-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-builtin-module/-/is-builtin-module-1.0.0.tgz";
        sha1 = "540572d34f7ac3119f8f76c30cbc1b1e037affbe";
      };
    }

    {
      name = "is-callable-1.1.4.tgz";
      path = fetchurl {
        name = "is-callable-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/is-callable/-/is-callable-1.1.4.tgz";
        sha1 = "1e1adf219e1eeb684d691f9d6a05ff0d30a24d75";
      };
    }

    {
      name = "is-ci-1.2.0.tgz";
      path = fetchurl {
        name = "is-ci-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/is-ci/-/is-ci-1.2.0.tgz";
        sha1 = "3f4a08d6303a09882cef3f0fb97439c5f5ce2d53";
      };
    }

    {
      name = "is-cidr-2.0.6.tgz";
      path = fetchurl {
        name = "is-cidr-2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/is-cidr/-/is-cidr-2.0.6.tgz";
        sha1 = "4b01c9693d8e18399dacd18a4f3d60ea5871ac60";
      };
    }

    {
      name = "is-data-descriptor-0.1.4.tgz";
      path = fetchurl {
        name = "is-data-descriptor-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz";
        sha1 = "0b5ee648388e2c860282e793f1856fec3f301b56";
      };
    }

    {
      name = "is-data-descriptor-1.0.0.tgz";
      path = fetchurl {
        name = "is-data-descriptor-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz";
        sha1 = "d84876321d0e7add03990406abbbbd36ba9268c7";
      };
    }

    {
      name = "is-date-object-1.0.1.tgz";
      path = fetchurl {
        name = "is-date-object-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.1.tgz";
        sha1 = "9aa20eb6aeebbff77fbd33e74ca01b33581d3a16";
      };
    }

    {
      name = "is-descriptor-0.1.6.tgz";
      path = fetchurl {
        name = "is-descriptor-0.1.6.tgz";
        url  = "https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-0.1.6.tgz";
        sha1 = "366d8240dde487ca51823b1ab9f07a10a78251ca";
      };
    }

    {
      name = "is-descriptor-1.0.2.tgz";
      path = fetchurl {
        name = "is-descriptor-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-1.0.2.tgz";
        sha1 = "3b159746a66604b04f8c81524ba365c5f14d86ec";
      };
    }

    {
      name = "is-directory-0.3.1.tgz";
      path = fetchurl {
        name = "is-directory-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/is-directory/-/is-directory-0.3.1.tgz";
        sha1 = "61339b6f2475fc772fd9c9d83f5c8575dc154ae1";
      };
    }

    {
      name = "is-dotfile-1.0.3.tgz";
      path = fetchurl {
        name = "is-dotfile-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/is-dotfile/-/is-dotfile-1.0.3.tgz";
        sha1 = "a6a2f32ffd2dfb04f5ca25ecd0f6b83cf798a1e1";
      };
    }

    {
      name = "is-equal-shallow-0.1.3.tgz";
      path = fetchurl {
        name = "is-equal-shallow-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz";
        sha1 = "2238098fc221de0bcfa5d9eac4c45d638aa1c534";
      };
    }

    {
      name = "is-extendable-0.1.1.tgz";
      path = fetchurl {
        name = "is-extendable-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz";
        sha1 = "62b110e289a471418e3ec36a617d472e301dfc89";
      };
    }

    {
      name = "is-extendable-1.0.1.tgz";
      path = fetchurl {
        name = "is-extendable-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-extendable/-/is-extendable-1.0.1.tgz";
        sha1 = "a7470f9e426733d81bd81e1155264e3a3507cab4";
      };
    }

    {
      name = "is-extglob-1.0.0.tgz";
      path = fetchurl {
        name = "is-extglob-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-extglob/-/is-extglob-1.0.0.tgz";
        sha1 = "ac468177c4943405a092fc8f29760c6ffc6206c0";
      };
    }

    {
      name = "is-extglob-2.1.1.tgz";
      path = fetchurl {
        name = "is-extglob-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz";
        sha1 = "a88c02535791f02ed37c76a1b9ea9773c833f8c2";
      };
    }

    {
      name = "is-finite-1.0.2.tgz";
      path = fetchurl {
        name = "is-finite-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-finite/-/is-finite-1.0.2.tgz";
        sha1 = "cc6677695602be550ef11e8b4aa6305342b6d0aa";
      };
    }

    {
      name = "is-fullwidth-code-point-1.0.0.tgz";
      path = fetchurl {
        name = "is-fullwidth-code-point-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz";
        sha1 = "ef9e31386f031a7f0d643af82fde50c457ef00cb";
      };
    }

    {
      name = "is-fullwidth-code-point-2.0.0.tgz";
      path = fetchurl {
        name = "is-fullwidth-code-point-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz";
        sha1 = "a3b30a5c4f199183167aaab93beefae3ddfb654f";
      };
    }

    {
      name = "is-function-1.0.1.tgz";
      path = fetchurl {
        name = "is-function-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-function/-/is-function-1.0.1.tgz";
        sha1 = "12cfb98b65b57dd3d193a3121f5f6e2f437602b5";
      };
    }

    {
      name = "is-git-url-1.0.0.tgz";
      path = fetchurl {
        name = "is-git-url-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-git-url/-/is-git-url-1.0.0.tgz";
        sha1 = "53f684cd143285b52c3244b4e6f28253527af66b";
      };
    }

    {
      name = "is-glob-2.0.1.tgz";
      path = fetchurl {
        name = "is-glob-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-glob/-/is-glob-2.0.1.tgz";
        sha1 = "d096f926a3ded5600f3fdfd91198cb0888c2d863";
      };
    }

    {
      name = "is-glob-3.1.0.tgz";
      path = fetchurl {
        name = "is-glob-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-glob/-/is-glob-3.1.0.tgz";
        sha1 = "7ba5ae24217804ac70707b96922567486cc3e84a";
      };
    }

    {
      name = "is-glob-4.0.0.tgz";
      path = fetchurl {
        name = "is-glob-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.0.tgz";
        sha1 = "9521c76845cc2610a85203ddf080a958c2ffabc0";
      };
    }

    {
      name = "is-installed-globally-0.1.0.tgz";
      path = fetchurl {
        name = "is-installed-globally-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-installed-globally/-/is-installed-globally-0.1.0.tgz";
        sha1 = "0dfd98f5a9111716dd535dda6492f67bf3d25a80";
      };
    }

    {
      name = "is-npm-1.0.0.tgz";
      path = fetchurl {
        name = "is-npm-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-npm/-/is-npm-1.0.0.tgz";
        sha1 = "f2fb63a65e4905b406c86072765a1a4dc793b9f4";
      };
    }

    {
      name = "is-number-2.1.0.tgz";
      path = fetchurl {
        name = "is-number-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-number/-/is-number-2.1.0.tgz";
        sha1 = "01fcbbb393463a548f2f466cce16dece49db908f";
      };
    }

    {
      name = "is-number-3.0.0.tgz";
      path = fetchurl {
        name = "is-number-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-number/-/is-number-3.0.0.tgz";
        sha1 = "24fd6201a4782cf50561c810276afc7d12d71195";
      };
    }

    {
      name = "is-number-4.0.0.tgz";
      path = fetchurl {
        name = "is-number-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-number/-/is-number-4.0.0.tgz";
        sha1 = "0026e37f5454d73e356dfe6564699867c6a7f0ff";
      };
    }

    {
      name = "is-obj-1.0.1.tgz";
      path = fetchurl {
        name = "is-obj-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-obj/-/is-obj-1.0.1.tgz";
        sha1 = "3e4729ac1f5fde025cd7d83a896dab9f4f67db0f";
      };
    }

    {
      name = "is-path-cwd-1.0.0.tgz";
      path = fetchurl {
        name = "is-path-cwd-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-1.0.0.tgz";
        sha1 = "d225ec23132e89edd38fda767472e62e65f1106d";
      };
    }

    {
      name = "is-path-in-cwd-1.0.1.tgz";
      path = fetchurl {
        name = "is-path-in-cwd-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-path-in-cwd/-/is-path-in-cwd-1.0.1.tgz";
        sha1 = "5ac48b345ef675339bd6c7a48a912110b241cf52";
      };
    }

    {
      name = "is-path-inside-1.0.1.tgz";
      path = fetchurl {
        name = "is-path-inside-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-1.0.1.tgz";
        sha1 = "8ef5b7de50437a3fdca6b4e865ef7aa55cb48036";
      };
    }

    {
      name = "is-plain-obj-1.1.0.tgz";
      path = fetchurl {
        name = "is-plain-obj-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-1.1.0.tgz";
        sha1 = "71a50c8429dfca773c92a390a4a03b39fcd51d3e";
      };
    }

    {
      name = "is-plain-object-2.0.4.tgz";
      path = fetchurl {
        name = "is-plain-object-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz";
        sha1 = "2c163b3fafb1b606d9d17928f05c2a1c38e07677";
      };
    }

    {
      name = "is-posix-bracket-0.1.1.tgz";
      path = fetchurl {
        name = "is-posix-bracket-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz";
        sha1 = "3334dc79774368e92f016e6fbc0a88f5cd6e6bc4";
      };
    }

    {
      name = "is-primitive-2.0.0.tgz";
      path = fetchurl {
        name = "is-primitive-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-primitive/-/is-primitive-2.0.0.tgz";
        sha1 = "207bab91638499c07b2adf240a41a87210034575";
      };
    }

    {
      name = "is-promise-2.1.0.tgz";
      path = fetchurl {
        name = "is-promise-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-promise/-/is-promise-2.1.0.tgz";
        sha1 = "79a2a9ece7f096e80f36d2b2f3bc16c1ff4bf3fa";
      };
    }

    {
      name = "is-redirect-1.0.0.tgz";
      path = fetchurl {
        name = "is-redirect-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-redirect/-/is-redirect-1.0.0.tgz";
        sha1 = "1d03dded53bd8db0f30c26e4f95d36fc7c87dc24";
      };
    }

    {
      name = "is-reference-1.1.0.tgz";
      path = fetchurl {
        name = "is-reference-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-reference/-/is-reference-1.1.0.tgz";
        sha1 = "50e6ef3f64c361e2c53c0416cdc9420037f2685b";
      };
    }

    {
      name = "is-regex-1.0.4.tgz";
      path = fetchurl {
        name = "is-regex-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-regex/-/is-regex-1.0.4.tgz";
        sha1 = "5517489b547091b0930e095654ced25ee97e9491";
      };
    }

    {
      name = "is-resolvable-1.1.0.tgz";
      path = fetchurl {
        name = "is-resolvable-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-resolvable/-/is-resolvable-1.1.0.tgz";
        sha1 = "fb18f87ce1feb925169c9a407c19318a3206ed88";
      };
    }

    {
      name = "is-retry-allowed-1.1.0.tgz";
      path = fetchurl {
        name = "is-retry-allowed-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-retry-allowed/-/is-retry-allowed-1.1.0.tgz";
        sha1 = "11a060568b67339444033d0125a61a20d564fb34";
      };
    }

    {
      name = "is-ssh-1.3.0.tgz";
      path = fetchurl {
        name = "is-ssh-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/is-ssh/-/is-ssh-1.3.0.tgz";
        sha1 = "ebea1169a2614da392a63740366c3ce049d8dff6";
      };
    }

    {
      name = "is-stream-1.1.0.tgz";
      path = fetchurl {
        name = "is-stream-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-stream/-/is-stream-1.1.0.tgz";
        sha1 = "12d4a3dd4e68e0b79ceb8dbc84173ae80d91ca44";
      };
    }

    {
      name = "is-subset-0.1.1.tgz";
      path = fetchurl {
        name = "is-subset-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-subset/-/is-subset-0.1.1.tgz";
        sha1 = "8a59117d932de1de00f245fcdd39ce43f1e939a6";
      };
    }

    {
      name = "is-symbol-1.0.1.tgz";
      path = fetchurl {
        name = "is-symbol-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.1.tgz";
        sha1 = "3cc59f00025194b6ab2e38dbae6689256b660572";
      };
    }

    {
      name = "is-text-path-1.0.1.tgz";
      path = fetchurl {
        name = "is-text-path-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-text-path/-/is-text-path-1.0.1.tgz";
        sha1 = "4e1aa0fb51bfbcb3e92688001397202c1775b66e";
      };
    }

    {
      name = "is-type-0.0.1.tgz";
      path = fetchurl {
        name = "is-type-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-type/-/is-type-0.0.1.tgz";
        sha1 = "f651d85c365d44955d14a51d8d7061f3f6b4779c";
      };
    }

    {
      name = "is-typedarray-1.0.0.tgz";
      path = fetchurl {
        name = "is-typedarray-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-typedarray/-/is-typedarray-1.0.0.tgz";
        sha1 = "e479c80858df0c1b11ddda6940f96011fcda4a9a";
      };
    }

    {
      name = "is-utf8-0.2.1.tgz";
      path = fetchurl {
        name = "is-utf8-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-utf8/-/is-utf8-0.2.1.tgz";
        sha1 = "4b0da1442104d1b336340e80797e865cf39f7d72";
      };
    }

    {
      name = "is-windows-1.0.2.tgz";
      path = fetchurl {
        name = "is-windows-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz";
        sha1 = "d1850eb9791ecd18e6182ce12a30f396634bb19d";
      };
    }

    {
      name = "isarray-0.0.1.tgz";
      path = fetchurl {
        name = "isarray-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz";
        sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
      };
    }

    {
      name = "isarray-1.0.0.tgz";
      path = fetchurl {
        name = "isarray-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz";
        sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
      };
    }

    {
      name = "isarray-2.0.1.tgz";
      path = fetchurl {
        name = "isarray-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-2.0.1.tgz";
        sha1 = "a37d94ed9cda2d59865c9f76fe596ee1f338741e";
      };
    }

    {
      name = "isbinaryfile-3.0.3.tgz";
      path = fetchurl {
        name = "isbinaryfile-3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-3.0.3.tgz";
        sha1 = "5d6def3edebf6e8ca8cae9c30183a804b5f8be80";
      };
    }

    {
      name = "isexe-2.0.0.tgz";
      path = fetchurl {
        name = "isexe-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz";
        sha1 = "e8fbf374dc556ff8947a10dcb0572d633f2cfa10";
      };
    }

    {
      name = "isobject-2.1.0.tgz";
      path = fetchurl {
        name = "isobject-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/isobject/-/isobject-2.1.0.tgz";
        sha1 = "f065561096a3f1da2ef46272f815c840d87e0c89";
      };
    }

    {
      name = "isobject-3.0.1.tgz";
      path = fetchurl {
        name = "isobject-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz";
        sha1 = "4e431e92b11a9731636aa1f9c8d1ccbcfdab78df";
      };
    }

    {
      name = "isstream-0.1.2.tgz";
      path = fetchurl {
        name = "isstream-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/isstream/-/isstream-0.1.2.tgz";
        sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
      };
    }

    {
      name = "issue-parser-3.0.0.tgz";
      path = fetchurl {
        name = "issue-parser-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/issue-parser/-/issue-parser-3.0.0.tgz";
        sha1 = "729d3fd5d6b86379cb0f513acc33b62f47ebd681";
      };
    }

    {
      name = "istextorbinary-2.1.0.tgz";
      path = fetchurl {
        name = "istextorbinary-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/istextorbinary/-/istextorbinary-2.1.0.tgz";
        sha1 = "dbed2a6f51be2f7475b68f89465811141b758874";
      };
    }

    {
      name = "ivy-codemirror-2.1.0.tgz";
      path = fetchurl {
        name = "ivy-codemirror-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ivy-codemirror/-/ivy-codemirror-2.1.0.tgz";
        sha1 = "c06f1606c375610bf62b007a21a9e63f5854175e";
      };
    }

    {
      name = "jade-0.26.3.tgz";
      path = fetchurl {
        name = "jade-0.26.3.tgz";
        url  = "https://registry.yarnpkg.com/jade/-/jade-0.26.3.tgz";
        sha1 = "8f10d7977d8d79f2f6ff862a81b0513ccb25686c";
      };
    }

    {
      name = "java-properties-0.2.10.tgz";
      path = fetchurl {
        name = "java-properties-0.2.10.tgz";
        url  = "https://registry.yarnpkg.com/java-properties/-/java-properties-0.2.10.tgz";
        sha1 = "2551560c25fa1ad94d998218178f233ad9b18f60";
      };
    }

    {
      name = "jimp-0.2.28.tgz";
      path = fetchurl {
        name = "jimp-0.2.28.tgz";
        url  = "https://registry.yarnpkg.com/jimp/-/jimp-0.2.28.tgz";
        sha1 = "dd529a937190f42957a7937d1acc3a7762996ea2";
      };
    }

    {
      name = "jpeg-js-0.1.2.tgz";
      path = fetchurl {
        name = "jpeg-js-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/jpeg-js/-/jpeg-js-0.1.2.tgz";
        sha1 = "135b992c0575c985cfa0f494a3227ed238583ece";
      };
    }

    {
      name = "jpeg-js-0.2.0.tgz";
      path = fetchurl {
        name = "jpeg-js-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/jpeg-js/-/jpeg-js-0.2.0.tgz";
        sha1 = "53e448ec9d263e683266467e9442d2c5a2ef5482";
      };
    }

    {
      name = "jquery-deferred-0.3.1.tgz";
      path = fetchurl {
        name = "jquery-deferred-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/jquery-deferred/-/jquery-deferred-0.3.1.tgz";
        sha1 = "596eca1caaff54f61b110962b23cafea74c35355";
      };
    }

    {
      name = "jquery-3.3.1.tgz";
      path = fetchurl {
        name = "jquery-3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/jquery/-/jquery-3.3.1.tgz";
        sha1 = "958ce29e81c9790f31be7792df5d4d95fc57fbca";
      };
    }

    {
      name = "js-base64-2.4.9.tgz";
      path = fetchurl {
        name = "js-base64-2.4.9.tgz";
        url  = "https://registry.yarnpkg.com/js-base64/-/js-base64-2.4.9.tgz";
        sha1 = "748911fb04f48a60c4771b375cac45a80df11c03";
      };
    }

    {
      name = "js-reporters-1.2.1.tgz";
      path = fetchurl {
        name = "js-reporters-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/js-reporters/-/js-reporters-1.2.1.tgz";
        sha1 = "f88c608e324a3373a95bcc45ad305e5c979c459b";
      };
    }

    {
      name = "js-string-escape-1.0.1.tgz";
      path = fetchurl {
        name = "js-string-escape-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/js-string-escape/-/js-string-escape-1.0.1.tgz";
        sha1 = "e2625badbc0d67c7533e9edc1068c587ae4137ef";
      };
    }

    {
      name = "js-tokens-4.0.0.tgz";
      path = fetchurl {
        name = "js-tokens-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz";
        sha1 = "19203fb59991df98e3a287050d4647cdeaf32499";
      };
    }

    {
      name = "js-tokens-3.0.2.tgz";
      path = fetchurl {
        name = "js-tokens-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/js-tokens/-/js-tokens-3.0.2.tgz";
        sha1 = "9866df395102130e38f7f996bceb65443209c25b";
      };
    }

    {
      name = "js-yaml-0.3.7.tgz";
      path = fetchurl {
        name = "js-yaml-0.3.7.tgz";
        url  = "https://registry.yarnpkg.com/js-yaml/-/js-yaml-0.3.7.tgz";
        sha1 = "d739d8ee86461e54b354d6a7d7d1f2ad9a167f62";
      };
    }

    {
      name = "js-yaml-3.12.0.tgz";
      path = fetchurl {
        name = "js-yaml-3.12.0.tgz";
        url  = "https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.12.0.tgz";
        sha1 = "eaed656ec8344f10f527c6bfa1b6e2244de167d1";
      };
    }

    {
      name = "jsbn-0.1.1.tgz";
      path = fetchurl {
        name = "jsbn-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/jsbn/-/jsbn-0.1.1.tgz";
        sha1 = "a5e654c2e5a2deb5f201d96cefbca80c0ef2f513";
      };
    }

    {
      name = "jsdom-11.12.0.tgz";
      path = fetchurl {
        name = "jsdom-11.12.0.tgz";
        url  = "https://registry.yarnpkg.com/jsdom/-/jsdom-11.12.0.tgz";
        sha1 = "1a80d40ddd378a1de59656e9e6dc5a3ba8657bc8";
      };
    }

    {
      name = "jsesc-1.3.0.tgz";
      path = fetchurl {
        name = "jsesc-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/jsesc/-/jsesc-1.3.0.tgz";
        sha1 = "46c3fec8c1892b12b0833db9bc7622176dbab34b";
      };
    }

    {
      name = "jsesc-2.5.1.tgz";
      path = fetchurl {
        name = "jsesc-2.5.1.tgz";
        url  = "https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.1.tgz";
        sha1 = "e421a2a8e20d6b0819df28908f782526b96dd1fe";
      };
    }

    {
      name = "jsesc-0.3.0.tgz";
      path = fetchurl {
        name = "jsesc-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/jsesc/-/jsesc-0.3.0.tgz";
        sha1 = "1bf5ee63b4539fe2e26d0c1e99c240b97a457972";
      };
    }

    {
      name = "jsesc-0.5.0.tgz";
      path = fetchurl {
        name = "jsesc-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/jsesc/-/jsesc-0.5.0.tgz";
        sha1 = "e7dee66e35d6fc16f710fe91d5cf69f70f08911d";
      };
    }

    {
      name = "jsmin-1.0.1.tgz";
      path = fetchurl {
        name = "jsmin-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/jsmin/-/jsmin-1.0.1.tgz";
        sha1 = "e7bd0dcd6496c3bf4863235bf461a3d98aa3b98c";
      };
    }

    {
      name = "json-parse-better-errors-1.0.2.tgz";
      path = fetchurl {
        name = "json-parse-better-errors-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz";
        sha1 = "bb867cfb3450e69107c131d1c514bab3dc8bcaa9";
      };
    }

    {
      name = "json-schema-traverse-0.3.1.tgz";
      path = fetchurl {
        name = "json-schema-traverse-0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.3.1.tgz";
        sha1 = "349a6d44c53a51de89b40805c5d5e59b417d3340";
      };
    }

    {
      name = "json-schema-traverse-0.4.1.tgz";
      path = fetchurl {
        name = "json-schema-traverse-0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz";
        sha1 = "69f6a87d9513ab8bb8fe63bdb0979c448e684660";
      };
    }

    {
      name = "json-schema-0.2.3.tgz";
      path = fetchurl {
        name = "json-schema-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/json-schema/-/json-schema-0.2.3.tgz";
        sha1 = "b480c892e59a2f05954ce727bd3f2a4e882f9e13";
      };
    }

    {
      name = "json-stable-stringify-without-jsonify-1.0.1.tgz";
      path = fetchurl {
        name = "json-stable-stringify-without-jsonify-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz";
        sha1 = "9db7b59496ad3f3cfef30a75142d2d930ad72651";
      };
    }

    {
      name = "json-stable-stringify-1.0.1.tgz";
      path = fetchurl {
        name = "json-stable-stringify-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stable-stringify/-/json-stable-stringify-1.0.1.tgz";
        sha1 = "9a759d39c5f2ff503fd5300646ed445f88c4f9af";
      };
    }

    {
      name = "json-stringify-safe-5.0.1.tgz";
      path = fetchurl {
        name = "json-stringify-safe-5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
      };
    }

    {
      name = "json5-0.5.1.tgz";
      path = fetchurl {
        name = "json5-0.5.1.tgz";
        url  = "https://registry.yarnpkg.com/json5/-/json5-0.5.1.tgz";
        sha1 = "1eade7acc012034ad84e2396767ead9fa5495821";
      };
    }

    {
      name = "jsonfile-2.4.0.tgz";
      path = fetchurl {
        name = "jsonfile-2.4.0.tgz";
        url  = "http://registry.npmjs.org/jsonfile/-/jsonfile-2.4.0.tgz";
        sha1 = "3736a2b428b87bbda0cc83b53fa3d633a35c2ae8";
      };
    }

    {
      name = "jsonfile-4.0.0.tgz";
      path = fetchurl {
        name = "jsonfile-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz";
        sha1 = "8771aae0799b64076b76640fca058f9c10e33ecb";
      };
    }

    {
      name = "jsonify-0.0.0.tgz";
      path = fetchurl {
        name = "jsonify-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonify/-/jsonify-0.0.0.tgz";
        sha1 = "2c74b6ee41d93ca51b7b5aaee8f503631d252a73";
      };
    }

    {
      name = "jsonlint-1.6.0.tgz";
      path = fetchurl {
        name = "jsonlint-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonlint/-/jsonlint-1.6.0.tgz";
        sha1 = "88aa46bc289a7ac93bb46cae2d58a187a9bb494a";
      };
    }

    {
      name = "jsonparse-1.3.1.tgz";
      path = fetchurl {
        name = "jsonparse-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/jsonparse/-/jsonparse-1.3.1.tgz";
        sha1 = "3f4dae4a91fac315f71062f8521cc239f1366280";
      };
    }

    {
      name = "jsontoxml-0.0.11.tgz";
      path = fetchurl {
        name = "jsontoxml-0.0.11.tgz";
        url  = "https://registry.yarnpkg.com/jsontoxml/-/jsontoxml-0.0.11.tgz";
        sha1 = "373ab5b2070be3737a5fb3e32fd1b7b81870caa4";
      };
    }

    {
      name = "jsprim-1.4.1.tgz";
      path = fetchurl {
        name = "jsprim-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/jsprim/-/jsprim-1.4.1.tgz";
        sha1 = "313e66bc1e5cc06e438bc1b7499c2e5c56acb6a2";
      };
    }

    {
      name = "just-extend-3.0.0.tgz";
      path = fetchurl {
        name = "just-extend-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/just-extend/-/just-extend-3.0.0.tgz";
        sha1 = "cee004031eaabf6406da03a7b84e4fe9d78ef288";
      };
    }

    {
      name = "jxLoader-0.1.1.tgz";
      path = fetchurl {
        name = "jxLoader-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/jxLoader/-/jxLoader-0.1.1.tgz";
        sha1 = "0134ea5144e533b594fc1ff25ff194e235c53ecd";
      };
    }

    {
      name = "kew-0.7.0.tgz";
      path = fetchurl {
        name = "kew-0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/kew/-/kew-0.7.0.tgz";
        sha1 = "79d93d2d33363d6fdd2970b335d9141ad591d79b";
      };
    }

    {
      name = "kind-of-3.2.2.tgz";
      path = fetchurl {
        name = "kind-of-3.2.2.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-3.2.2.tgz";
        sha1 = "31ea21a734bab9bbb0f32466d893aea51e4a3c64";
      };
    }

    {
      name = "kind-of-4.0.0.tgz";
      path = fetchurl {
        name = "kind-of-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-4.0.0.tgz";
        sha1 = "20813df3d712928b207378691a45066fae72dd57";
      };
    }

    {
      name = "kind-of-5.1.0.tgz";
      path = fetchurl {
        name = "kind-of-5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-5.1.0.tgz";
        sha1 = "729c91e2d857b7a419a1f9aa65685c4c33f5845d";
      };
    }

    {
      name = "kind-of-6.0.2.tgz";
      path = fetchurl {
        name = "kind-of-6.0.2.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.2.tgz";
        sha1 = "01146b36a6218e64e58f3a8d66de5d7fc6f6d051";
      };
    }

    {
      name = "klaw-1.3.1.tgz";
      path = fetchurl {
        name = "klaw-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/klaw/-/klaw-1.3.1.tgz";
        sha1 = "4088433b46b3b1ba259d78785d8e96f73ba02439";
      };
    }

    {
      name = "kuler-1.0.0.tgz";
      path = fetchurl {
        name = "kuler-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/kuler/-/kuler-1.0.0.tgz";
        sha1 = "904ad31c373b781695854d32be33818bf1d60250";
      };
    }

    {
      name = "latest-version-3.1.0.tgz";
      path = fetchurl {
        name = "latest-version-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/latest-version/-/latest-version-3.1.0.tgz";
        sha1 = "a205383fea322b33b5ae3b18abee0dc2f356ee15";
      };
    }

    {
      name = "lazy-property-1.0.0.tgz";
      path = fetchurl {
        name = "lazy-property-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lazy-property/-/lazy-property-1.0.0.tgz";
        sha1 = "84ddc4b370679ba8bd4cdcfa4c06b43d57111147";
      };
    }

    {
      name = "lcid-1.0.0.tgz";
      path = fetchurl {
        name = "lcid-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lcid/-/lcid-1.0.0.tgz";
        sha1 = "308accafa0bc483a3867b4b6f2b9506251d1b835";
      };
    }

    {
      name = "lcid-2.0.0.tgz";
      path = fetchurl {
        name = "lcid-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lcid/-/lcid-2.0.0.tgz";
        sha1 = "6ef5d2df60e52f82eb228a4c373e8d1f397253cf";
      };
    }

    {
      name = "leek-0.0.24.tgz";
      path = fetchurl {
        name = "leek-0.0.24.tgz";
        url  = "https://registry.yarnpkg.com/leek/-/leek-0.0.24.tgz";
        sha1 = "e400e57f0e60d8ef2bd4d068dc428a54345dbcda";
      };
    }

    {
      name = "left-pad-1.3.0.tgz";
      path = fetchurl {
        name = "left-pad-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/left-pad/-/left-pad-1.3.0.tgz";
        sha1 = "5b8a3a7765dfe001261dde915589e782f8c94d1e";
      };
    }

    {
      name = "levn-0.3.0.tgz";
      path = fetchurl {
        name = "levn-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/levn/-/levn-0.3.0.tgz";
        sha1 = "3b09924edf9f083c0490fdd4c0bc4421e04764ee";
      };
    }

    {
      name = "libcipm-2.0.2.tgz";
      path = fetchurl {
        name = "libcipm-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/libcipm/-/libcipm-2.0.2.tgz";
        sha1 = "4f38c2b37acf2ec156936cef1cbf74636568fc7b";
      };
    }

    {
      name = "libnpmhook-4.0.1.tgz";
      path = fetchurl {
        name = "libnpmhook-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/libnpmhook/-/libnpmhook-4.0.1.tgz";
        sha1 = "63641654de772cbeb96a88527a7fd5456ec3c2d7";
      };
    }

    {
      name = "libnpx-10.2.0.tgz";
      path = fetchurl {
        name = "libnpx-10.2.0.tgz";
        url  = "https://registry.yarnpkg.com/libnpx/-/libnpx-10.2.0.tgz";
        sha1 = "1bf4a1c9f36081f64935eb014041da10855e3102";
      };
    }

    {
      name = "linkify-it-2.0.3.tgz";
      path = fetchurl {
        name = "linkify-it-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/linkify-it/-/linkify-it-2.0.3.tgz";
        sha1 = "d94a4648f9b1c179d64fa97291268bdb6ce9434f";
      };
    }

    {
      name = "livereload-js-2.3.0.tgz";
      path = fetchurl {
        name = "livereload-js-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/livereload-js/-/livereload-js-2.3.0.tgz";
        sha1 = "c3ab22e8aaf5bf3505d80d098cbad67726548c9a";
      };
    }

    {
      name = "load-bmfont-1.4.0.tgz";
      path = fetchurl {
        name = "load-bmfont-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/load-bmfont/-/load-bmfont-1.4.0.tgz";
        sha1 = "75f17070b14a8c785fe7f5bee2e6fd4f98093b6b";
      };
    }

    {
      name = "load-json-file-1.1.0.tgz";
      path = fetchurl {
        name = "load-json-file-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/load-json-file/-/load-json-file-1.1.0.tgz";
        sha1 = "956905708d58b4bab4c2261b04f59f31c99374c0";
      };
    }

    {
      name = "load-json-file-4.0.0.tgz";
      path = fetchurl {
        name = "load-json-file-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/load-json-file/-/load-json-file-4.0.0.tgz";
        sha1 = "2f5f45ab91e33216234fd53adab668eb4ec0993b";
      };
    }

    {
      name = "loader-runner-2.3.0.tgz";
      path = fetchurl {
        name = "loader-runner-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/loader-runner/-/loader-runner-2.3.0.tgz";
        sha1 = "f482aea82d543e07921700d5a46ef26fdac6b8a2";
      };
    }

    {
      name = "loader-utils-1.1.0.tgz";
      path = fetchurl {
        name = "loader-utils-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/loader-utils/-/loader-utils-1.1.0.tgz";
        sha1 = "c98aef488bcceda2ffb5e2de646d6a754429f5cd";
      };
    }

    {
      name = "loader.js-4.7.0.tgz";
      path = fetchurl {
        name = "loader.js-4.7.0.tgz";
        url  = "https://registry.yarnpkg.com/loader.js/-/loader.js-4.7.0.tgz";
        sha1 = "a1a52902001c83631efde9688b8ab3799325ef1f";
      };
    }

    {
      name = "locate-character-2.0.5.tgz";
      path = fetchurl {
        name = "locate-character-2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/locate-character/-/locate-character-2.0.5.tgz";
        sha1 = "f2d2614d49820ecb3c92d80d193b8db755f74c0f";
      };
    }

    {
      name = "locate-path-2.0.0.tgz";
      path = fetchurl {
        name = "locate-path-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz";
        sha1 = "2b568b265eec944c6d9c0de9c3dbbbca0354cd8e";
      };
    }

    {
      name = "locate-path-3.0.0.tgz";
      path = fetchurl {
        name = "locate-path-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-3.0.0.tgz";
        sha1 = "dbec3b3ab759758071b58fe59fc41871af21400e";
      };
    }

    {
      name = "lock-verify-2.0.2.tgz";
      path = fetchurl {
        name = "lock-verify-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/lock-verify/-/lock-verify-2.0.2.tgz";
        sha1 = "148e4f85974915c9e3c34d694b7de9ecb18ee7a8";
      };
    }

    {
      name = "lockfile-1.0.4.tgz";
      path = fetchurl {
        name = "lockfile-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/lockfile/-/lockfile-1.0.4.tgz";
        sha1 = "07f819d25ae48f87e538e6578b6964a4981a5609";
      };
    }

    {
      name = "lodash-es-4.17.10.tgz";
      path = fetchurl {
        name = "lodash-es-4.17.10.tgz";
        url  = "https://registry.yarnpkg.com/lodash-es/-/lodash-es-4.17.10.tgz";
        sha1 = "62cd7104cdf5dd87f235a837f0ede0e8e5117e05";
      };
    }

    {
      name = "lodash._baseassign-3.2.0.tgz";
      path = fetchurl {
        name = "lodash._baseassign-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._baseassign/-/lodash._baseassign-3.2.0.tgz";
        sha1 = "8c38a099500f215ad09e59f1722fd0c52bfe0a4e";
      };
    }

    {
      name = "lodash._basebind-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._basebind-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._basebind/-/lodash._basebind-2.3.0.tgz";
        sha1 = "2b5bc452a0e106143b21869f233bdb587417d248";
      };
    }

    {
      name = "lodash._basecopy-3.0.1.tgz";
      path = fetchurl {
        name = "lodash._basecopy-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._basecopy/-/lodash._basecopy-3.0.1.tgz";
        sha1 = "8da0e6a876cf344c0ad8a54882111dd3c5c7ca36";
      };
    }

    {
      name = "lodash._basecreate-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._basecreate-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._basecreate/-/lodash._basecreate-2.3.0.tgz";
        sha1 = "9b88a86a4dcff7b7f3c61d83a2fcfc0671ec9de0";
      };
    }

    {
      name = "lodash._basecreatecallback-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._basecreatecallback-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._basecreatecallback/-/lodash._basecreatecallback-2.3.0.tgz";
        sha1 = "37b2ab17591a339e988db3259fcd46019d7ac362";
      };
    }

    {
      name = "lodash._basecreatewrapper-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._basecreatewrapper-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._basecreatewrapper/-/lodash._basecreatewrapper-2.3.0.tgz";
        sha1 = "aa0c61ad96044c3933376131483a9759c3651247";
      };
    }

    {
      name = "lodash._baseflatten-3.1.4.tgz";
      path = fetchurl {
        name = "lodash._baseflatten-3.1.4.tgz";
        url  = "https://registry.yarnpkg.com/lodash._baseflatten/-/lodash._baseflatten-3.1.4.tgz";
        sha1 = "0770ff80131af6e34f3b511796a7ba5214e65ff7";
      };
    }

    {
      name = "lodash._basetostring-3.0.1.tgz";
      path = fetchurl {
        name = "lodash._basetostring-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._basetostring/-/lodash._basetostring-3.0.1.tgz";
        sha1 = "d1861d877f824a52f669832dcaf3ee15566a07d5";
      };
    }

    {
      name = "lodash._baseuniq-4.6.0.tgz";
      path = fetchurl {
        name = "lodash._baseuniq-4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._baseuniq/-/lodash._baseuniq-4.6.0.tgz";
        sha1 = "0ebb44e456814af7905c6212fa2c9b2d51b841e8";
      };
    }

    {
      name = "lodash._basevalues-3.0.0.tgz";
      path = fetchurl {
        name = "lodash._basevalues-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._basevalues/-/lodash._basevalues-3.0.0.tgz";
        sha1 = "5b775762802bde3d3297503e26300820fdf661b7";
      };
    }

    {
      name = "lodash._bindcallback-3.0.1.tgz";
      path = fetchurl {
        name = "lodash._bindcallback-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._bindcallback/-/lodash._bindcallback-3.0.1.tgz";
        sha1 = "e531c27644cf8b57a99e17ed95b35c748789392e";
      };
    }

    {
      name = "lodash._createassigner-3.1.1.tgz";
      path = fetchurl {
        name = "lodash._createassigner-3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._createassigner/-/lodash._createassigner-3.1.1.tgz";
        sha1 = "838a5bae2fdaca63ac22dee8e19fa4e6d6970b11";
      };
    }

    {
      name = "lodash._createset-4.0.3.tgz";
      path = fetchurl {
        name = "lodash._createset-4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/lodash._createset/-/lodash._createset-4.0.3.tgz";
        sha1 = "0f4659fbb09d75194fa9e2b88a6644d363c9fe26";
      };
    }

    {
      name = "lodash._createwrapper-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._createwrapper-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._createwrapper/-/lodash._createwrapper-2.3.0.tgz";
        sha1 = "d1aae1102dadf440e8e06fc133a6edd7fe146075";
      };
    }

    {
      name = "lodash._escapehtmlchar-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._escapehtmlchar-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._escapehtmlchar/-/lodash._escapehtmlchar-2.3.0.tgz";
        sha1 = "d03da6bd82eedf38dc0a5b503d740ecd0e894592";
      };
    }

    {
      name = "lodash._escapestringchar-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._escapestringchar-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._escapestringchar/-/lodash._escapestringchar-2.3.0.tgz";
        sha1 = "cce73ae60fc6da55d2bf8a0679c23ca2bab149fc";
      };
    }

    {
      name = "lodash._getnative-3.9.1.tgz";
      path = fetchurl {
        name = "lodash._getnative-3.9.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._getnative/-/lodash._getnative-3.9.1.tgz";
        sha1 = "570bc7dede46d61cdcde687d65d3eecbaa3aaff5";
      };
    }

    {
      name = "lodash._htmlescapes-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._htmlescapes-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._htmlescapes/-/lodash._htmlescapes-2.3.0.tgz";
        sha1 = "1ca98863cadf1fa1d82c84f35f31e40556a04f3a";
      };
    }

    {
      name = "lodash._isiterateecall-3.0.9.tgz";
      path = fetchurl {
        name = "lodash._isiterateecall-3.0.9.tgz";
        url  = "https://registry.yarnpkg.com/lodash._isiterateecall/-/lodash._isiterateecall-3.0.9.tgz";
        sha1 = "5203ad7ba425fae842460e696db9cf3e6aac057c";
      };
    }

    {
      name = "lodash._objecttypes-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._objecttypes-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._objecttypes/-/lodash._objecttypes-2.3.0.tgz";
        sha1 = "6a3ea3987dd6eeb8021b2d5c9c303549cc2bae1e";
      };
    }

    {
      name = "lodash._reinterpolate-3.0.0.tgz";
      path = fetchurl {
        name = "lodash._reinterpolate-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._reinterpolate/-/lodash._reinterpolate-3.0.0.tgz";
        sha1 = "0ccf2d89166af03b3663c796538b75ac6e114d9d";
      };
    }

    {
      name = "lodash._reinterpolate-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._reinterpolate-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._reinterpolate/-/lodash._reinterpolate-2.3.0.tgz";
        sha1 = "03ee9d85c0e55cbd590d71608a295bdda51128ec";
      };
    }

    {
      name = "lodash._renative-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._renative-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._renative/-/lodash._renative-2.3.0.tgz";
        sha1 = "77d8edd4ced26dd5971f9e15a5f772e4e317fbd3";
      };
    }

    {
      name = "lodash._reunescapedhtml-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._reunescapedhtml-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._reunescapedhtml/-/lodash._reunescapedhtml-2.3.0.tgz";
        sha1 = "db920b55ac7f3ff825939aceb9ba2c231713d24d";
      };
    }

    {
      name = "lodash._root-3.0.1.tgz";
      path = fetchurl {
        name = "lodash._root-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash._root/-/lodash._root-3.0.1.tgz";
        sha1 = "fba1c4524c19ee9a5f8136b4609f017cf4ded692";
      };
    }

    {
      name = "lodash._setbinddata-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._setbinddata-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._setbinddata/-/lodash._setbinddata-2.3.0.tgz";
        sha1 = "e5610490acd13277d59858d95b5f2727f1508f04";
      };
    }

    {
      name = "lodash._shimkeys-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._shimkeys-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._shimkeys/-/lodash._shimkeys-2.3.0.tgz";
        sha1 = "611f93149e3e6c721096b48769ef29537ada8ba9";
      };
    }

    {
      name = "lodash._slice-2.3.0.tgz";
      path = fetchurl {
        name = "lodash._slice-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash._slice/-/lodash._slice-2.3.0.tgz";
        sha1 = "147198132859972e4680ca29a5992c855669aa5c";
      };
    }

    {
      name = "lodash.assign-3.2.0.tgz";
      path = fetchurl {
        name = "lodash.assign-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.assign/-/lodash.assign-3.2.0.tgz";
        sha1 = "3ce9f0234b4b2223e296b8fa0ac1fee8ebca64fa";
      };
    }

    {
      name = "lodash.assign-4.2.0.tgz";
      path = fetchurl {
        name = "lodash.assign-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.assign/-/lodash.assign-4.2.0.tgz";
        sha1 = "0d99f3ccd7a6d261d19bdaeb9245005d285808e7";
      };
    }

    {
      name = "lodash.assignin-4.2.0.tgz";
      path = fetchurl {
        name = "lodash.assignin-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.assignin/-/lodash.assignin-4.2.0.tgz";
        sha1 = "ba8df5fb841eb0a3e8044232b0e263a8dc6a28a2";
      };
    }

    {
      name = "lodash.bind-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.bind-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.bind/-/lodash.bind-2.3.0.tgz";
        sha1 = "c2a8e18b68e5ecc152e2b168266116fea5b016cc";
      };
    }

    {
      name = "lodash.capitalize-4.2.1.tgz";
      path = fetchurl {
        name = "lodash.capitalize-4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.capitalize/-/lodash.capitalize-4.2.1.tgz";
        sha1 = "f826c9b4e2a8511d84e3aca29db05e1a4f3b72a9";
      };
    }

    {
      name = "lodash.castarray-4.4.0.tgz";
      path = fetchurl {
        name = "lodash.castarray-4.4.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.castarray/-/lodash.castarray-4.4.0.tgz";
        sha1 = "c02513515e309daddd4c24c60cfddcf5976d9115";
      };
    }

    {
      name = "lodash.clonedeep-4.5.0.tgz";
      path = fetchurl {
        name = "lodash.clonedeep-4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz";
        sha1 = "e23f3f9c4f8fbdde872529c1071857a086e5ccef";
      };
    }

    {
      name = "lodash.debounce-3.1.1.tgz";
      path = fetchurl {
        name = "lodash.debounce-3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.debounce/-/lodash.debounce-3.1.1.tgz";
        sha1 = "812211c378a94cc29d5aa4e3346cf0bfce3a7df5";
      };
    }

    {
      name = "lodash.debounce-4.0.8.tgz";
      path = fetchurl {
        name = "lodash.debounce-4.0.8.tgz";
        url  = "https://registry.yarnpkg.com/lodash.debounce/-/lodash.debounce-4.0.8.tgz";
        sha1 = "82d79bff30a67c4005ffd5e2515300ad9ca4d7af";
      };
    }

    {
      name = "lodash.defaults-4.2.0.tgz";
      path = fetchurl {
        name = "lodash.defaults-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.defaults/-/lodash.defaults-4.2.0.tgz";
        sha1 = "d09178716ffea4dde9e5fb7b37f6f0802274580c";
      };
    }

    {
      name = "lodash.defaults-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.defaults-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.defaults/-/lodash.defaults-2.3.0.tgz";
        sha1 = "a832b001f138f3bb9721c2819a2a7cc5ae21ed25";
      };
    }

    {
      name = "lodash.defaultsdeep-4.6.0.tgz";
      path = fetchurl {
        name = "lodash.defaultsdeep-4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.defaultsdeep/-/lodash.defaultsdeep-4.6.0.tgz";
        sha1 = "bec1024f85b1bd96cbea405b23c14ad6443a6f81";
      };
    }

    {
      name = "lodash.escape-3.2.0.tgz";
      path = fetchurl {
        name = "lodash.escape-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.escape/-/lodash.escape-3.2.0.tgz";
        sha1 = "995ee0dc18c1b48cc92effae71a10aab5b487698";
      };
    }

    {
      name = "lodash.escape-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.escape-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.escape/-/lodash.escape-2.3.0.tgz";
        sha1 = "844c38c58f844e1362ebe96726159b62cf5f2a58";
      };
    }

    {
      name = "lodash.escaperegexp-4.1.2.tgz";
      path = fetchurl {
        name = "lodash.escaperegexp-4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.escaperegexp/-/lodash.escaperegexp-4.1.2.tgz";
        sha1 = "64762c48618082518ac3df4ccf5d5886dae20347";
      };
    }

    {
      name = "lodash.find-4.6.0.tgz";
      path = fetchurl {
        name = "lodash.find-4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.find/-/lodash.find-4.6.0.tgz";
        sha1 = "cb0704d47ab71789ffa0de8b97dd926fb88b13b1";
      };
    }

    {
      name = "lodash.flatten-3.0.2.tgz";
      path = fetchurl {
        name = "lodash.flatten-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.flatten/-/lodash.flatten-3.0.2.tgz";
        sha1 = "de1cf57758f8f4479319d35c3e9cc60c4501938c";
      };
    }

    {
      name = "lodash.foreach-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.foreach-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.foreach/-/lodash.foreach-2.3.0.tgz";
        sha1 = "083404c91e846ee77245fdf9d76519c68b2af168";
      };
    }

    {
      name = "lodash.forown-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.forown-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.forown/-/lodash.forown-2.3.0.tgz";
        sha1 = "24fb4aaf800d45fc2dc60bfec3ce04c836a3ad7f";
      };
    }

    {
      name = "lodash.get-4.4.2.tgz";
      path = fetchurl {
        name = "lodash.get-4.4.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.get/-/lodash.get-4.4.2.tgz";
        sha1 = "2d177f652fa31e939b4438d5341499dfa3825e99";
      };
    }

    {
      name = "lodash.identity-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.identity-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.identity/-/lodash.identity-2.3.0.tgz";
        sha1 = "6b01a210c9485355c2a913b48b6711219a173ded";
      };
    }

    {
      name = "lodash.isarguments-3.1.0.tgz";
      path = fetchurl {
        name = "lodash.isarguments-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isarguments/-/lodash.isarguments-3.1.0.tgz";
        sha1 = "2f573d85c6a24289ff00663b491c1d338ff3458a";
      };
    }

    {
      name = "lodash.isarray-3.0.4.tgz";
      path = fetchurl {
        name = "lodash.isarray-3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isarray/-/lodash.isarray-3.0.4.tgz";
        sha1 = "79e4eb88c36a8122af86f844aa9bcd851b5fbb55";
      };
    }

    {
      name = "lodash.isfunction-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.isfunction-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isfunction/-/lodash.isfunction-2.3.0.tgz";
        sha1 = "6b2973e47a647cf12e70d676aea13643706e5267";
      };
    }

    {
      name = "lodash.isobject-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.isobject-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isobject/-/lodash.isobject-2.3.0.tgz";
        sha1 = "2e16d3fc583da9831968953f2d8e6d73434f6799";
      };
    }

    {
      name = "lodash.isplainobject-4.0.6.tgz";
      path = fetchurl {
        name = "lodash.isplainobject-4.0.6.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz";
        sha1 = "7c526a52d89b45c45cc690b88163be0497f550cb";
      };
    }

    {
      name = "lodash.isstring-4.0.1.tgz";
      path = fetchurl {
        name = "lodash.isstring-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isstring/-/lodash.isstring-4.0.1.tgz";
        sha1 = "d527dfb5456eca7cc9bb95d5daeaf88ba54a5451";
      };
    }

    {
      name = "lodash.keys-3.1.2.tgz";
      path = fetchurl {
        name = "lodash.keys-3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.keys/-/lodash.keys-3.1.2.tgz";
        sha1 = "4dbc0472b156be50a0b286855d1bd0b0c656098a";
      };
    }

    {
      name = "lodash.keys-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.keys-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.keys/-/lodash.keys-2.3.0.tgz";
        sha1 = "b350f4f92caa9f45a4a2ecf018454cf2f28ae253";
      };
    }

    {
      name = "lodash.memoize-4.1.2.tgz";
      path = fetchurl {
        name = "lodash.memoize-4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.memoize/-/lodash.memoize-4.1.2.tgz";
        sha1 = "bcc6c49a42a2840ed997f323eada5ecd182e0bfe";
      };
    }

    {
      name = "lodash.merge-4.6.1.tgz";
      path = fetchurl {
        name = "lodash.merge-4.6.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.1.tgz";
        sha1 = "adc25d9cb99b9391c59624f379fbba60d7111d54";
      };
    }

    {
      name = "lodash.mergewith-4.6.1.tgz";
      path = fetchurl {
        name = "lodash.mergewith-4.6.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.mergewith/-/lodash.mergewith-4.6.1.tgz";
        sha1 = "639057e726c3afbdb3e7d42741caa8d6e4335927";
      };
    }

    {
      name = "lodash.noop-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.noop-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.noop/-/lodash.noop-2.3.0.tgz";
        sha1 = "3059d628d51bbf937cd2a0b6fc3a7f212a669c2c";
      };
    }

    {
      name = "lodash.omit-4.5.0.tgz";
      path = fetchurl {
        name = "lodash.omit-4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.omit/-/lodash.omit-4.5.0.tgz";
        sha1 = "6eb19ae5a1ee1dd9df0b969e66ce0b7fa30b5e60";
      };
    }

    {
      name = "lodash.restparam-3.6.1.tgz";
      path = fetchurl {
        name = "lodash.restparam-3.6.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.restparam/-/lodash.restparam-3.6.1.tgz";
        sha1 = "936a4e309ef330a7645ed4145986c85ae5b20805";
      };
    }

    {
      name = "lodash.sortby-4.7.0.tgz";
      path = fetchurl {
        name = "lodash.sortby-4.7.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.sortby/-/lodash.sortby-4.7.0.tgz";
        sha1 = "edd14c824e2cc9c1e0b0a1b42bb5210516a42438";
      };
    }

    {
      name = "lodash.support-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.support-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.support/-/lodash.support-2.3.0.tgz";
        sha1 = "7eaf038af4f0d6aab776b44aa6dcfc80334c9bfd";
      };
    }

    {
      name = "lodash.template-3.6.2.tgz";
      path = fetchurl {
        name = "lodash.template-3.6.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.template/-/lodash.template-3.6.2.tgz";
        sha1 = "f8cdecc6169a255be9098ae8b0c53d378931d14f";
      };
    }

    {
      name = "lodash.template-4.4.0.tgz";
      path = fetchurl {
        name = "lodash.template-4.4.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.template/-/lodash.template-4.4.0.tgz";
        sha1 = "e73a0385c8355591746e020b99679c690e68fba0";
      };
    }

    {
      name = "lodash.template-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.template-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.template/-/lodash.template-2.3.0.tgz";
        sha1 = "4e3e29c433b4cfea675ec835e6f12391c61fd22b";
      };
    }

    {
      name = "lodash.templatesettings-3.1.1.tgz";
      path = fetchurl {
        name = "lodash.templatesettings-3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.templatesettings/-/lodash.templatesettings-3.1.1.tgz";
        sha1 = "fb307844753b66b9f1afa54e262c745307dba8e5";
      };
    }

    {
      name = "lodash.templatesettings-4.1.0.tgz";
      path = fetchurl {
        name = "lodash.templatesettings-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.templatesettings/-/lodash.templatesettings-4.1.0.tgz";
        sha1 = "2b4d4e95ba440d915ff08bc899e4553666713316";
      };
    }

    {
      name = "lodash.templatesettings-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.templatesettings-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.templatesettings/-/lodash.templatesettings-2.3.0.tgz";
        sha1 = "303d132c342710040d5a18efaa2d572fd03f8cdc";
      };
    }

    {
      name = "lodash.toarray-4.4.0.tgz";
      path = fetchurl {
        name = "lodash.toarray-4.4.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.toarray/-/lodash.toarray-4.4.0.tgz";
        sha1 = "24c4bfcd6b2fba38bfd0594db1179d8e9b656561";
      };
    }

    {
      name = "lodash.unescape-4.0.1.tgz";
      path = fetchurl {
        name = "lodash.unescape-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lodash.unescape/-/lodash.unescape-4.0.1.tgz";
        sha1 = "bf2249886ce514cda112fae9218cdc065211fc9c";
      };
    }

    {
      name = "lodash.union-4.6.0.tgz";
      path = fetchurl {
        name = "lodash.union-4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.union/-/lodash.union-4.6.0.tgz";
        sha1 = "48bb5088409f16f1821666641c44dd1aaae3cd88";
      };
    }

    {
      name = "lodash.uniq-4.5.0.tgz";
      path = fetchurl {
        name = "lodash.uniq-4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.uniq/-/lodash.uniq-4.5.0.tgz";
        sha1 = "d0225373aeb652adc1bc82e4945339a842754773";
      };
    }

    {
      name = "lodash.uniqby-4.7.0.tgz";
      path = fetchurl {
        name = "lodash.uniqby-4.7.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.uniqby/-/lodash.uniqby-4.7.0.tgz";
        sha1 = "d99c07a669e9e6d24e1362dfe266c67616af1302";
      };
    }

    {
      name = "lodash.values-2.3.0.tgz";
      path = fetchurl {
        name = "lodash.values-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.values/-/lodash.values-2.3.0.tgz";
        sha1 = "ca96fbe60a20b0b0ec2ba2ba5fc6a765bd14a3ba";
      };
    }

    {
      name = "lodash.without-4.4.0.tgz";
      path = fetchurl {
        name = "lodash.without-4.4.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.without/-/lodash.without-4.4.0.tgz";
        sha1 = "3cd4574a00b67bae373a94b748772640507b7aac";
      };
    }

    {
      name = "lodash-3.10.1.tgz";
      path = fetchurl {
        name = "lodash-3.10.1.tgz";
        url  = "http://registry.npmjs.org/lodash/-/lodash-3.10.1.tgz";
        sha1 = "5bf45e8e49ba4189e17d482789dfd15bd140b7b6";
      };
    }

    {
      name = "lodash-4.17.10.tgz";
      path = fetchurl {
        name = "lodash-4.17.10.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.10.tgz";
        sha1 = "1b7793cf7259ea38fb3661d4d38b3260af8ae4e7";
      };
    }

    {
      name = "lodash-2.4.2.tgz";
      path = fetchurl {
        name = "lodash-2.4.2.tgz";
        url  = "http://registry.npmjs.org/lodash/-/lodash-2.4.2.tgz";
        sha1 = "fadd834b9683073da179b3eae6d9c0d15053f73e";
      };
    }

    {
      name = "log-symbols-2.2.0.tgz";
      path = fetchurl {
        name = "log-symbols-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/log-symbols/-/log-symbols-2.2.0.tgz";
        sha1 = "5740e1c5d6f0dfda4ad9323b5332107ef6b4c40a";
      };
    }

    {
      name = "logform-1.9.1.tgz";
      path = fetchurl {
        name = "logform-1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/logform/-/logform-1.9.1.tgz";
        sha1 = "58b29d7b11c332456d7a217e17b48a13ad69d60a";
      };
    }

    {
      name = "loglevel-colored-level-prefix-1.0.0.tgz";
      path = fetchurl {
        name = "loglevel-colored-level-prefix-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/loglevel-colored-level-prefix/-/loglevel-colored-level-prefix-1.0.0.tgz";
        sha1 = "6a40218fdc7ae15fc76c3d0f3e676c465388603e";
      };
    }

    {
      name = "loglevel-1.6.1.tgz";
      path = fetchurl {
        name = "loglevel-1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/loglevel/-/loglevel-1.6.1.tgz";
        sha1 = "e0fc95133b6ef276cdc8887cdaf24aa6f156f8fa";
      };
    }

    {
      name = "lolex-2.7.4.tgz";
      path = fetchurl {
        name = "lolex-2.7.4.tgz";
        url  = "https://registry.yarnpkg.com/lolex/-/lolex-2.7.4.tgz";
        sha1 = "6514de2c3291e9d6f09d49ddce4a95f7d4d5a93f";
      };
    }

    {
      name = "long-4.0.0.tgz";
      path = fetchurl {
        name = "long-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/long/-/long-4.0.0.tgz";
        sha1 = "9a7b71cfb7d361a194ea555241c92f7468d5bf28";
      };
    }

    {
      name = "long-3.2.0.tgz";
      path = fetchurl {
        name = "long-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/long/-/long-3.2.0.tgz";
        sha1 = "d821b7138ca1cb581c172990ef14db200b5c474b";
      };
    }

    {
      name = "loose-envify-1.4.0.tgz";
      path = fetchurl {
        name = "loose-envify-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/loose-envify/-/loose-envify-1.4.0.tgz";
        sha1 = "71ee51fa7be4caec1a63839f7e682d8132d30caf";
      };
    }

    {
      name = "loud-rejection-1.6.0.tgz";
      path = fetchurl {
        name = "loud-rejection-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/loud-rejection/-/loud-rejection-1.6.0.tgz";
        sha1 = "5b46f80147edee578870f086d04821cf998e551f";
      };
    }

    {
      name = "lower-case-1.1.4.tgz";
      path = fetchurl {
        name = "lower-case-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/lower-case/-/lower-case-1.1.4.tgz";
        sha1 = "9a2cabd1b9e8e0ae993a4bf7d5875c39c42e8eac";
      };
    }

    {
      name = "lowercase-keys-1.0.1.tgz";
      path = fetchurl {
        name = "lowercase-keys-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-1.0.1.tgz";
        sha1 = "6f9e30b47084d971a7c820ff15a6c5167b74c26f";
      };
    }

    {
      name = "lru-cache-2.7.3.tgz";
      path = fetchurl {
        name = "lru-cache-2.7.3.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-2.7.3.tgz";
        sha1 = "6d4524e8b955f95d4f5b58851ce21dd72fb4e952";
      };
    }

    {
      name = "lru-cache-4.1.3.tgz";
      path = fetchurl {
        name = "lru-cache-4.1.3.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-4.1.3.tgz";
        sha1 = "a1175cf3496dfc8436c156c334b4955992bce69c";
      };
    }

    {
      name = "magic-string-0.24.1.tgz";
      path = fetchurl {
        name = "magic-string-0.24.1.tgz";
        url  = "https://registry.yarnpkg.com/magic-string/-/magic-string-0.24.1.tgz";
        sha1 = "7e38e5f126cae9f15e71f0cf8e450818ca7d5a8f";
      };
    }

    {
      name = "make-dir-1.3.0.tgz";
      path = fetchurl {
        name = "make-dir-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/make-dir/-/make-dir-1.3.0.tgz";
        sha1 = "79c1033b80515bd6d24ec9933e860ca75ee27f0c";
      };
    }

    {
      name = "make-fetch-happen-4.0.1.tgz";
      path = fetchurl {
        name = "make-fetch-happen-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/make-fetch-happen/-/make-fetch-happen-4.0.1.tgz";
        sha1 = "141497cb878f243ba93136c83d8aba12c216c083";
      };
    }

    {
      name = "make-fetch-happen-3.0.0.tgz";
      path = fetchurl {
        name = "make-fetch-happen-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/make-fetch-happen/-/make-fetch-happen-3.0.0.tgz";
        sha1 = "7b661d2372fc4710ab5cc8e1fa3c290eea69a961";
      };
    }

    {
      name = "make-plural-4.2.0.tgz";
      path = fetchurl {
        name = "make-plural-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/make-plural/-/make-plural-4.2.0.tgz";
        sha1 = "03edfc34a2aee630a57e209369ef26ee3ca69590";
      };
    }

    {
      name = "makeerror-1.0.11.tgz";
      path = fetchurl {
        name = "makeerror-1.0.11.tgz";
        url  = "https://registry.yarnpkg.com/makeerror/-/makeerror-1.0.11.tgz";
        sha1 = "e01a5c9109f2af79660e4e8b9587790184f5a96c";
      };
    }

    {
      name = "mamacro-0.0.3.tgz";
      path = fetchurl {
        name = "mamacro-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/mamacro/-/mamacro-0.0.3.tgz";
        sha1 = "ad2c9576197c9f1abf308d0787865bd975a3f3e4";
      };
    }

    {
      name = "map-age-cleaner-0.1.2.tgz";
      path = fetchurl {
        name = "map-age-cleaner-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/map-age-cleaner/-/map-age-cleaner-0.1.2.tgz";
        sha1 = "098fb15538fd3dbe461f12745b0ca8568d4e3f74";
      };
    }

    {
      name = "map-cache-0.2.2.tgz";
      path = fetchurl {
        name = "map-cache-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/map-cache/-/map-cache-0.2.2.tgz";
        sha1 = "c32abd0bd6525d9b051645bb4f26ac5dc98a0dbf";
      };
    }

    {
      name = "map-obj-1.0.1.tgz";
      path = fetchurl {
        name = "map-obj-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/map-obj/-/map-obj-1.0.1.tgz";
        sha1 = "d933ceb9205d82bdcf4886f6742bdc2b4dea146d";
      };
    }

    {
      name = "map-obj-2.0.0.tgz";
      path = fetchurl {
        name = "map-obj-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/map-obj/-/map-obj-2.0.0.tgz";
        sha1 = "a65cd29087a92598b8791257a523e021222ac1f9";
      };
    }

    {
      name = "map-visit-1.0.0.tgz";
      path = fetchurl {
        name = "map-visit-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/map-visit/-/map-visit-1.0.0.tgz";
        sha1 = "ecdca8f13144e660f1b5bd41f12f3479d98dfb8f";
      };
    }

    {
      name = "markdown-it-terminal-0.1.0.tgz";
      path = fetchurl {
        name = "markdown-it-terminal-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/markdown-it-terminal/-/markdown-it-terminal-0.1.0.tgz";
        sha1 = "545abd8dd01c3d62353bfcea71db580b51d22bd9";
      };
    }

    {
      name = "markdown-it-8.4.2.tgz";
      path = fetchurl {
        name = "markdown-it-8.4.2.tgz";
        url  = "https://registry.yarnpkg.com/markdown-it/-/markdown-it-8.4.2.tgz";
        sha1 = "386f98998dc15a37722aa7722084f4020bdd9b54";
      };
    }

    {
      name = "marked-terminal-3.1.1.tgz";
      path = fetchurl {
        name = "marked-terminal-3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/marked-terminal/-/marked-terminal-3.1.1.tgz";
        sha1 = "1e726816ddc4552a83393228ff0952b6cd4e5e04";
      };
    }

    {
      name = "marked-0.5.0.tgz";
      path = fetchurl {
        name = "marked-0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/marked/-/marked-0.5.0.tgz";
        sha1 = "9e590bad31584a48ff405b33ab1c0dd25172288e";
      };
    }

    {
      name = "matcher-collection-1.0.5.tgz";
      path = fetchurl {
        name = "matcher-collection-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/matcher-collection/-/matcher-collection-1.0.5.tgz";
        sha1 = "2ee095438372cb8884f058234138c05c644ec339";
      };
    }

    {
      name = "math-random-1.0.1.tgz";
      path = fetchurl {
        name = "math-random-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/math-random/-/math-random-1.0.1.tgz";
        sha1 = "8b3aac588b8a66e4975e3cdea67f7bb329601fac";
      };
    }

    {
      name = "md5-hex-2.0.0.tgz";
      path = fetchurl {
        name = "md5-hex-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/md5-hex/-/md5-hex-2.0.0.tgz";
        sha1 = "d0588e9f1c74954492ecd24ac0ac6ce997d92e33";
      };
    }

    {
      name = "md5-o-matic-0.1.1.tgz";
      path = fetchurl {
        name = "md5-o-matic-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/md5-o-matic/-/md5-o-matic-0.1.1.tgz";
        sha1 = "822bccd65e117c514fab176b25945d54100a03c3";
      };
    }

    {
      name = "md5.js-1.3.4.tgz";
      path = fetchurl {
        name = "md5.js-1.3.4.tgz";
        url  = "https://registry.yarnpkg.com/md5.js/-/md5.js-1.3.4.tgz";
        sha1 = "e9bdbde94a20a5ac18b04340fc5764d5b09d901d";
      };
    }

    {
      name = "mdurl-1.0.1.tgz";
      path = fetchurl {
        name = "mdurl-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/mdurl/-/mdurl-1.0.1.tgz";
        sha1 = "fe85b2ec75a59037f2adfec100fd6c601761152e";
      };
    }

    {
      name = "meant-1.0.1.tgz";
      path = fetchurl {
        name = "meant-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/meant/-/meant-1.0.1.tgz";
        sha1 = "66044fea2f23230ec806fb515efea29c44d2115d";
      };
    }

    {
      name = "media-typer-0.3.0.tgz";
      path = fetchurl {
        name = "media-typer-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/media-typer/-/media-typer-0.3.0.tgz";
        sha1 = "8710d7af0aa626f8fffa1ce00168545263255748";
      };
    }

    {
      name = "mem-1.1.0.tgz";
      path = fetchurl {
        name = "mem-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/mem/-/mem-1.1.0.tgz";
        sha1 = "5edd52b485ca1d900fe64895505399a0dfa45f76";
      };
    }

    {
      name = "mem-4.0.0.tgz";
      path = fetchurl {
        name = "mem-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/mem/-/mem-4.0.0.tgz";
        sha1 = "6437690d9471678f6cc83659c00cbafcd6b0cdaf";
      };
    }

    {
      name = "memory-fs-0.4.1.tgz";
      path = fetchurl {
        name = "memory-fs-0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.4.1.tgz";
        sha1 = "3a9a20b8462523e447cfbc7e8bb80ed667bfc552";
      };
    }

    {
      name = "memory-streams-0.1.3.tgz";
      path = fetchurl {
        name = "memory-streams-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/memory-streams/-/memory-streams-0.1.3.tgz";
        sha1 = "d9b0017b4b87f1d92f55f2745c9caacb1dc93ceb";
      };
    }

    {
      name = "meow-3.7.0.tgz";
      path = fetchurl {
        name = "meow-3.7.0.tgz";
        url  = "https://registry.yarnpkg.com/meow/-/meow-3.7.0.tgz";
        sha1 = "72cb668b425228290abbfa856892587308a801fb";
      };
    }

    {
      name = "meow-4.0.1.tgz";
      path = fetchurl {
        name = "meow-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/meow/-/meow-4.0.1.tgz";
        sha1 = "d48598f6f4b1472f35bf6317a95945ace347f975";
      };
    }

    {
      name = "merge-defaults-0.2.1.tgz";
      path = fetchurl {
        name = "merge-defaults-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/merge-defaults/-/merge-defaults-0.2.1.tgz";
        sha1 = "dd42248eb96bb6a51521724321c72ff9583dde80";
      };
    }

    {
      name = "merge-descriptors-1.0.1.tgz";
      path = fetchurl {
        name = "merge-descriptors-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/merge-descriptors/-/merge-descriptors-1.0.1.tgz";
        sha1 = "b00aaa556dd8b44568150ec9d1b953f3f90cbb61";
      };
    }

    {
      name = "merge-trees-1.0.1.tgz";
      path = fetchurl {
        name = "merge-trees-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/merge-trees/-/merge-trees-1.0.1.tgz";
        sha1 = "ccbe674569787f9def17fd46e6525f5700bbd23e";
      };
    }

    {
      name = "merge-trees-2.0.0.tgz";
      path = fetchurl {
        name = "merge-trees-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/merge-trees/-/merge-trees-2.0.0.tgz";
        sha1 = "a560d796e566c5d9b2c40472a2967cca48d85161";
      };
    }

    {
      name = "merge2-1.2.2.tgz";
      path = fetchurl {
        name = "merge2-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/merge2/-/merge2-1.2.2.tgz";
        sha1 = "03212e3da8d86c4d8523cebd6318193414f94e34";
      };
    }

    {
      name = "merge-1.2.0.tgz";
      path = fetchurl {
        name = "merge-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/merge/-/merge-1.2.0.tgz";
        sha1 = "7531e39d4949c281a66b8c5a6e0265e8b05894da";
      };
    }

    {
      name = "messageformat-parser-1.1.0.tgz";
      path = fetchurl {
        name = "messageformat-parser-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/messageformat-parser/-/messageformat-parser-1.1.0.tgz";
        sha1 = "13ba2250a76bbde8e0fca0dbb3475f95c594a90a";
      };
    }

    {
      name = "messageformat-1.1.1.tgz";
      path = fetchurl {
        name = "messageformat-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/messageformat/-/messageformat-1.1.1.tgz";
        sha1 = "ceaa2e6c86929d4807058275a7372b1bd963bdf6";
      };
    }

    {
      name = "methods-1.1.2.tgz";
      path = fetchurl {
        name = "methods-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/methods/-/methods-1.1.2.tgz";
        sha1 = "5529a4d67654134edcc5266656835b0f851afcee";
      };
    }

    {
      name = "micromatch-2.3.11.tgz";
      path = fetchurl {
        name = "micromatch-2.3.11.tgz";
        url  = "https://registry.yarnpkg.com/micromatch/-/micromatch-2.3.11.tgz";
        sha1 = "86677c97d1720b363431d04d0d15293bd38c1565";
      };
    }

    {
      name = "micromatch-3.1.10.tgz";
      path = fetchurl {
        name = "micromatch-3.1.10.tgz";
        url  = "https://registry.yarnpkg.com/micromatch/-/micromatch-3.1.10.tgz";
        sha1 = "70859bc95c9840952f359a068a3fc49f9ecfac23";
      };
    }

    {
      name = "miller-rabin-4.0.1.tgz";
      path = fetchurl {
        name = "miller-rabin-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/miller-rabin/-/miller-rabin-4.0.1.tgz";
        sha1 = "f080351c865b0dc562a8462966daa53543c78a4d";
      };
    }

    {
      name = "mime-db-1.36.0.tgz";
      path = fetchurl {
        name = "mime-db-1.36.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.36.0.tgz";
        sha1 = "5020478db3c7fe93aad7bbcc4dcf869c43363397";
      };
    }

    {
      name = "mime-types-2.1.20.tgz";
      path = fetchurl {
        name = "mime-types-2.1.20.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.20.tgz";
        sha1 = "930cb719d571e903738520f8470911548ca2cc19";
      };
    }

    {
      name = "mime-1.4.1.tgz";
      path = fetchurl {
        name = "mime-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/mime/-/mime-1.4.1.tgz";
        sha1 = "121f9ebc49e3766f311a76e1fa1c8003c4b03aa6";
      };
    }

    {
      name = "mime-1.6.0.tgz";
      path = fetchurl {
        name = "mime-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/mime/-/mime-1.6.0.tgz";
        sha1 = "32cd9e5c64553bd58d19a568af452acff04981b1";
      };
    }

    {
      name = "mime-2.3.1.tgz";
      path = fetchurl {
        name = "mime-2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/mime/-/mime-2.3.1.tgz";
        sha1 = "b1621c54d63b97c47d3cfe7f7215f7d64517c369";
      };
    }

    {
      name = "mimic-fn-1.2.0.tgz";
      path = fetchurl {
        name = "mimic-fn-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-1.2.0.tgz";
        sha1 = "820c86a39334640e99516928bd03fca88057d022";
      };
    }

    {
      name = "min-document-2.19.0.tgz";
      path = fetchurl {
        name = "min-document-2.19.0.tgz";
        url  = "https://registry.yarnpkg.com/min-document/-/min-document-2.19.0.tgz";
        sha1 = "7bd282e3f5842ed295bb748cdd9f1ffa2c824685";
      };
    }

    {
      name = "minimalistic-assert-1.0.1.tgz";
      path = fetchurl {
        name = "minimalistic-assert-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz";
        sha1 = "2e194de044626d4a10e7f7fbc00ce73e83e4d5c7";
      };
    }

    {
      name = "minimalistic-crypto-utils-1.0.1.tgz";
      path = fetchurl {
        name = "minimalistic-crypto-utils-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/minimalistic-crypto-utils/-/minimalistic-crypto-utils-1.0.1.tgz";
        sha1 = "f6c00c1c0b082246e5c4d99dfb8c7c083b2b582a";
      };
    }

    {
      name = "minimatch-3.0.4.tgz";
      path = fetchurl {
        name = "minimatch-3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz";
        sha1 = "5166e286457f03306064be5497e8dbb0c3d32083";
      };
    }

    {
      name = "minimatch-0.2.14.tgz";
      path = fetchurl {
        name = "minimatch-0.2.14.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-0.2.14.tgz";
        sha1 = "c74e780574f63c6f9a090e90efbe6ef53a6a756a";
      };
    }

    {
      name = "minimist-options-3.0.2.tgz";
      path = fetchurl {
        name = "minimist-options-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/minimist-options/-/minimist-options-3.0.2.tgz";
        sha1 = "fba4c8191339e13ecf4d61beb03f070103f3d954";
      };
    }

    {
      name = "minimist-0.0.8.tgz";
      path = fetchurl {
        name = "minimist-0.0.8.tgz";
        url  = "http://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      };
    }

    {
      name = "minimist-1.2.0.tgz";
      path = fetchurl {
        name = "minimist-1.2.0.tgz";
        url  = "http://registry.npmjs.org/minimist/-/minimist-1.2.0.tgz";
        sha1 = "a35008b20f41383eec1fb914f4cd5df79a264284";
      };
    }

    {
      name = "minimist-0.0.10.tgz";
      path = fetchurl {
        name = "minimist-0.0.10.tgz";
        url  = "http://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
        sha1 = "de3f98543dbf96082be48ad1a0c7cda836301dcf";
      };
    }

    {
      name = "minipass-2.3.4.tgz";
      path = fetchurl {
        name = "minipass-2.3.4.tgz";
        url  = "https://registry.yarnpkg.com/minipass/-/minipass-2.3.4.tgz";
        sha1 = "4768d7605ed6194d6d576169b9e12ef71e9d9957";
      };
    }

    {
      name = "minizlib-1.1.0.tgz";
      path = fetchurl {
        name = "minizlib-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/minizlib/-/minizlib-1.1.0.tgz";
        sha1 = "11e13658ce46bc3a70a267aac58359d1e0c29ceb";
      };
    }

    {
      name = "mississippi-2.0.0.tgz";
      path = fetchurl {
        name = "mississippi-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/mississippi/-/mississippi-2.0.0.tgz";
        sha1 = "3442a508fafc28500486feea99409676e4ee5a6f";
      };
    }

    {
      name = "mississippi-3.0.0.tgz";
      path = fetchurl {
        name = "mississippi-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/mississippi/-/mississippi-3.0.0.tgz";
        sha1 = "ea0a3291f97e0b5e8776b363d5f0a12d94c67022";
      };
    }

    {
      name = "mixin-deep-1.3.1.tgz";
      path = fetchurl {
        name = "mixin-deep-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/mixin-deep/-/mixin-deep-1.3.1.tgz";
        sha1 = "a49e7268dce1a0d9698e45326c5626df3543d0fe";
      };
    }

    {
      name = "mkdirp-0.3.0.tgz";
      path = fetchurl {
        name = "mkdirp-0.3.0.tgz";
        url  = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.0.tgz";
        sha1 = "1bbf5ab1ba827af23575143490426455f481fe1e";
      };
    }

    {
      name = "mkdirp-0.3.5.tgz";
      path = fetchurl {
        name = "mkdirp-0.3.5.tgz";
        url  = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      };
    }

    {
      name = "mkdirp-0.5.1.tgz";
      path = fetchurl {
        name = "mkdirp-0.5.1.tgz";
        url  = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz";
        sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
      };
    }

    {
      name = "mktemp-0.4.0.tgz";
      path = fetchurl {
        name = "mktemp-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/mktemp/-/mktemp-0.4.0.tgz";
        sha1 = "6d0515611c8a8c84e484aa2000129b98e981ff0b";
      };
    }

    {
      name = "mocha-1.13.0.tgz";
      path = fetchurl {
        name = "mocha-1.13.0.tgz";
        url  = "http://registry.npmjs.org/mocha/-/mocha-1.13.0.tgz";
        sha1 = "8d8fa4e310b94cc6efeb3ed26aeca96dea93307c";
      };
    }

    {
      name = "modify-values-1.0.1.tgz";
      path = fetchurl {
        name = "modify-values-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/modify-values/-/modify-values-1.0.1.tgz";
        sha1 = "b3939fa605546474e3e3e3c63d64bd43b4ee6022";
      };
    }

    {
      name = "moment-timezone-0.5.21.tgz";
      path = fetchurl {
        name = "moment-timezone-0.5.21.tgz";
        url  = "https://registry.yarnpkg.com/moment-timezone/-/moment-timezone-0.5.21.tgz";
        sha1 = "3cba247d84492174dbf71de2a9848fa13207b845";
      };
    }

    {
      name = "moment-2.22.2.tgz";
      path = fetchurl {
        name = "moment-2.22.2.tgz";
        url  = "https://registry.yarnpkg.com/moment/-/moment-2.22.2.tgz";
        sha1 = "3c257f9839fc0e93ff53149632239eb90783ff66";
      };
    }

    {
      name = "moo-server-1.3.0.tgz";
      path = fetchurl {
        name = "moo-server-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/moo-server/-/moo-server-1.3.0.tgz";
        sha1 = "5dc79569565a10d6efed5439491e69d2392e58f1";
      };
    }

    {
      name = "morgan-1.9.1.tgz";
      path = fetchurl {
        name = "morgan-1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/morgan/-/morgan-1.9.1.tgz";
        sha1 = "0a8d16734a1d9afbc824b99df87e738e58e2da59";
      };
    }

    {
      name = "mout-1.1.0.tgz";
      path = fetchurl {
        name = "mout-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/mout/-/mout-1.1.0.tgz";
        sha1 = "0b29d41e6a80fa9e2d4a5be9d602e1d9d02177f6";
      };
    }

    {
      name = "move-concurrently-1.0.1.tgz";
      path = fetchurl {
        name = "move-concurrently-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/move-concurrently/-/move-concurrently-1.0.1.tgz";
        sha1 = "be2c005fda32e0b29af1f05d7c4b33214c701f92";
      };
    }

    {
      name = "ms-0.7.1.tgz";
      path = fetchurl {
        name = "ms-0.7.1.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-0.7.1.tgz";
        sha1 = "9cd13c03adbff25b65effde7ce864ee952017098";
      };
    }

    {
      name = "ms-2.0.0.tgz";
      path = fetchurl {
        name = "ms-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz";
        sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
      };
    }

    {
      name = "ms-2.1.1.tgz";
      path = fetchurl {
        name = "ms-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.1.1.tgz";
        sha1 = "30a5864eb3ebb0a66f2ebe6d727af06a09d86e0a";
      };
    }

    {
      name = "mustache-2.3.2.tgz";
      path = fetchurl {
        name = "mustache-2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/mustache/-/mustache-2.3.2.tgz";
        sha1 = "a6d4d9c3f91d13359ab889a812954f9230a3d0c5";
      };
    }

    {
      name = "mute-stream-0.0.6.tgz";
      path = fetchurl {
        name = "mute-stream-0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.6.tgz";
        sha1 = "48962b19e169fd1dfc240b3f1e7317627bbc47db";
      };
    }

    {
      name = "mute-stream-0.0.7.tgz";
      path = fetchurl {
        name = "mute-stream-0.0.7.tgz";
        url  = "https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.7.tgz";
        sha1 = "3075ce93bc21b8fab43e1bc4da7e8115ed1e7bab";
      };
    }

    {
      name = "najax-1.0.4.tgz";
      path = fetchurl {
        name = "najax-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/najax/-/najax-1.0.4.tgz";
        sha1 = "63fd8dbf15d18f24dc895b3a16fec66c136b8084";
      };
    }

    {
      name = "nan-2.11.0.tgz";
      path = fetchurl {
        name = "nan-2.11.0.tgz";
        url  = "https://registry.yarnpkg.com/nan/-/nan-2.11.0.tgz";
        sha1 = "574e360e4d954ab16966ec102c0c049fd961a099";
      };
    }

    {
      name = "nanomatch-1.2.13.tgz";
      path = fetchurl {
        name = "nanomatch-1.2.13.tgz";
        url  = "https://registry.yarnpkg.com/nanomatch/-/nanomatch-1.2.13.tgz";
        sha1 = "b87a8aa4fc0de8fe6be88895b38983ff265bd119";
      };
    }

    {
      name = "native-promise-only-0.8.1.tgz";
      path = fetchurl {
        name = "native-promise-only-0.8.1.tgz";
        url  = "https://registry.yarnpkg.com/native-promise-only/-/native-promise-only-0.8.1.tgz";
        sha1 = "20a318c30cb45f71fe7adfbf7b21c99c1472ef11";
      };
    }

    {
      name = "natural-compare-1.4.0.tgz";
      path = fetchurl {
        name = "natural-compare-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz";
        sha1 = "4abebfeed7541f2c27acfb29bdbbd15c8d5ba4f7";
      };
    }

    {
      name = "needle-2.2.2.tgz";
      path = fetchurl {
        name = "needle-2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/needle/-/needle-2.2.2.tgz";
        sha1 = "1120ca4c41f2fcc6976fd28a8968afe239929418";
      };
    }

    {
      name = "negotiator-0.6.1.tgz";
      path = fetchurl {
        name = "negotiator-0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.1.tgz";
        sha1 = "2b327184e8992101177b28563fb5e7102acd0ca9";
      };
    }

    {
      name = "neo-async-2.5.2.tgz";
      path = fetchurl {
        name = "neo-async-2.5.2.tgz";
        url  = "https://registry.yarnpkg.com/neo-async/-/neo-async-2.5.2.tgz";
        sha1 = "489105ce7bc54e709d736b195f82135048c50fcc";
      };
    }

    {
      name = "nerf-dart-1.0.0.tgz";
      path = fetchurl {
        name = "nerf-dart-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/nerf-dart/-/nerf-dart-1.0.0.tgz";
        sha1 = "e6dab7febf5ad816ea81cf5c629c5a0ebde72c1a";
      };
    }

    {
      name = "nice-try-1.0.5.tgz";
      path = fetchurl {
        name = "nice-try-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/nice-try/-/nice-try-1.0.5.tgz";
        sha1 = "a3378a7696ce7d223e88fc9b764bd7ef1089e366";
      };
    }

    {
      name = "nise-1.4.4.tgz";
      path = fetchurl {
        name = "nise-1.4.4.tgz";
        url  = "https://registry.yarnpkg.com/nise/-/nise-1.4.4.tgz";
        sha1 = "b8d9dd35334c99e514b75e46fcc38e358caecdd0";
      };
    }

    {
      name = "no-case-2.3.2.tgz";
      path = fetchurl {
        name = "no-case-2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/no-case/-/no-case-2.3.2.tgz";
        sha1 = "60b813396be39b3f1288a4c1ed5d1e7d28b464ac";
      };
    }

    {
      name = "node-emoji-1.8.1.tgz";
      path = fetchurl {
        name = "node-emoji-1.8.1.tgz";
        url  = "https://registry.yarnpkg.com/node-emoji/-/node-emoji-1.8.1.tgz";
        sha1 = "6eec6bfb07421e2148c75c6bba72421f8530a826";
      };
    }

    {
      name = "node-fetch-npm-2.0.2.tgz";
      path = fetchurl {
        name = "node-fetch-npm-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/node-fetch-npm/-/node-fetch-npm-2.0.2.tgz";
        sha1 = "7258c9046182dca345b4208eda918daf33697ff7";
      };
    }

    {
      name = "node-fetch-2.2.0.tgz";
      path = fetchurl {
        name = "node-fetch-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/node-fetch/-/node-fetch-2.2.0.tgz";
        sha1 = "4ee79bde909262f9775f731e3656d0db55ced5b5";
      };
    }

    {
      name = "node-gyp-3.8.0.tgz";
      path = fetchurl {
        name = "node-gyp-3.8.0.tgz";
        url  = "https://registry.yarnpkg.com/node-gyp/-/node-gyp-3.8.0.tgz";
        sha1 = "540304261c330e80d0d5edce253a68cb3964218c";
      };
    }

    {
      name = "node-int64-0.4.0.tgz";
      path = fetchurl {
        name = "node-int64-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/node-int64/-/node-int64-0.4.0.tgz";
        sha1 = "87a9065cdb355d3182d8f94ce11188b825c68a3b";
      };
    }

    {
      name = "node-libs-browser-2.1.0.tgz";
      path = fetchurl {
        name = "node-libs-browser-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/node-libs-browser/-/node-libs-browser-2.1.0.tgz";
        sha1 = "5f94263d404f6e44767d726901fff05478d600df";
      };
    }

    {
      name = "node-modules-path-1.0.1.tgz";
      path = fetchurl {
        name = "node-modules-path-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/node-modules-path/-/node-modules-path-1.0.1.tgz";
        sha1 = "40096b08ce7ad0ea14680863af449c7c75a5d1c8";
      };
    }

    {
      name = "node-notifier-5.2.1.tgz";
      path = fetchurl {
        name = "node-notifier-5.2.1.tgz";
        url  = "https://registry.yarnpkg.com/node-notifier/-/node-notifier-5.2.1.tgz";
        sha1 = "fa313dd08f5517db0e2502e5758d664ac69f9dea";
      };
    }

    {
      name = "node-pre-gyp-0.10.3.tgz";
      path = fetchurl {
        name = "node-pre-gyp-0.10.3.tgz";
        url  = "https://registry.yarnpkg.com/node-pre-gyp/-/node-pre-gyp-0.10.3.tgz";
        sha1 = "3070040716afdc778747b61b6887bf78880b80fc";
      };
    }

    {
      name = "node-rest-client-1.8.0.tgz";
      path = fetchurl {
        name = "node-rest-client-1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/node-rest-client/-/node-rest-client-1.8.0.tgz";
        sha1 = "8d3c566b817e27394cb7273783a41caefe3e5955";
      };
    }

    {
      name = "node-sass-4.9.3.tgz";
      path = fetchurl {
        name = "node-sass-4.9.3.tgz";
        url  = "https://registry.yarnpkg.com/node-sass/-/node-sass-4.9.3.tgz";
        sha1 = "f407cf3d66f78308bb1e346b24fa428703196224";
      };
    }

    {
      name = "nomnom-1.8.1.tgz";
      path = fetchurl {
        name = "nomnom-1.8.1.tgz";
        url  = "https://registry.yarnpkg.com/nomnom/-/nomnom-1.8.1.tgz";
        sha1 = "2151f722472ba79e50a76fc125bb8c8f2e4dc2a7";
      };
    }

    {
      name = "nopt-3.0.6.tgz";
      path = fetchurl {
        name = "nopt-3.0.6.tgz";
        url  = "https://registry.yarnpkg.com/nopt/-/nopt-3.0.6.tgz";
        sha1 = "c6465dbf08abcd4db359317f79ac68a646b28ff9";
      };
    }

    {
      name = "nopt-4.0.1.tgz";
      path = fetchurl {
        name = "nopt-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/nopt/-/nopt-4.0.1.tgz";
        sha1 = "d0d4685afd5415193c8c7505602d0d17cd64474d";
      };
    }

    {
      name = "normalize-package-data-2.4.0.tgz";
      path = fetchurl {
        name = "normalize-package-data-2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.4.0.tgz";
        sha1 = "12f95a307d58352075a04907b84ac8be98ac012f";
      };
    }

    {
      name = "normalize-path-2.1.1.tgz";
      path = fetchurl {
        name = "normalize-path-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.1.1.tgz";
        sha1 = "1ab28b556e198363a8c1a6f7e6fa20137fe6aed9";
      };
    }

    {
      name = "normalize-range-0.1.2.tgz";
      path = fetchurl {
        name = "normalize-range-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/normalize-range/-/normalize-range-0.1.2.tgz";
        sha1 = "2d10c06bdfd312ea9777695a4d28439456b75942";
      };
    }

    {
      name = "normalize-url-3.3.0.tgz";
      path = fetchurl {
        name = "normalize-url-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-url/-/normalize-url-3.3.0.tgz";
        sha1 = "b2e1c4dc4f7c6d57743df733a4f5978d18650559";
      };
    }

    {
      name = "normalize.css-4.1.1.tgz";
      path = fetchurl {
        name = "normalize.css-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/normalize.css/-/normalize.css-4.1.1.tgz";
        sha1 = "4f0b1d5a235383252b04d8566b866cc5fcad9f0c";
      };
    }

    {
      name = "npm-audit-report-1.3.1.tgz";
      path = fetchurl {
        name = "npm-audit-report-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/npm-audit-report/-/npm-audit-report-1.3.1.tgz";
        sha1 = "e79ea1fcb5ffaf3031102b389d5222c2b0459632";
      };
    }

    {
      name = "npm-bundled-1.0.5.tgz";
      path = fetchurl {
        name = "npm-bundled-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/npm-bundled/-/npm-bundled-1.0.5.tgz";
        sha1 = "3c1732b7ba936b3a10325aef616467c0ccbcc979";
      };
    }

    {
      name = "npm-cache-filename-1.0.2.tgz";
      path = fetchurl {
        name = "npm-cache-filename-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/npm-cache-filename/-/npm-cache-filename-1.0.2.tgz";
        sha1 = "ded306c5b0bfc870a9e9faf823bc5f283e05ae11";
      };
    }

    {
      name = "npm-git-info-1.0.3.tgz";
      path = fetchurl {
        name = "npm-git-info-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/npm-git-info/-/npm-git-info-1.0.3.tgz";
        sha1 = "a933c42ec321e80d3646e0d6e844afe94630e1d5";
      };
    }

    {
      name = "npm-install-checks-3.0.0.tgz";
      path = fetchurl {
        name = "npm-install-checks-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/npm-install-checks/-/npm-install-checks-3.0.0.tgz";
        sha1 = "d4aecdfd51a53e3723b7b2f93b2ee28e307bc0d7";
      };
    }

    {
      name = "npm-lifecycle-2.1.0.tgz";
      path = fetchurl {
        name = "npm-lifecycle-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/npm-lifecycle/-/npm-lifecycle-2.1.0.tgz";
        sha1 = "1eda2eedb82db929e3a0c50341ab0aad140ed569";
      };
    }

    {
      name = "npm-logical-tree-1.2.1.tgz";
      path = fetchurl {
        name = "npm-logical-tree-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/npm-logical-tree/-/npm-logical-tree-1.2.1.tgz";
        sha1 = "44610141ca24664cad35d1e607176193fd8f5b88";
      };
    }

    {
      name = "npm-package-arg-6.1.0.tgz";
      path = fetchurl {
        name = "npm-package-arg-6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/npm-package-arg/-/npm-package-arg-6.1.0.tgz";
        sha1 = "15ae1e2758a5027efb4c250554b85a737db7fcc1";
      };
    }

    {
      name = "npm-packlist-1.1.11.tgz";
      path = fetchurl {
        name = "npm-packlist-1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/npm-packlist/-/npm-packlist-1.1.11.tgz";
        sha1 = "84e8c683cbe7867d34b1d357d893ce29e28a02de";
      };
    }

    {
      name = "npm-pick-manifest-2.1.0.tgz";
      path = fetchurl {
        name = "npm-pick-manifest-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/npm-pick-manifest/-/npm-pick-manifest-2.1.0.tgz";
        sha1 = "dc381bdd670c35d81655e1d5a94aa3dd4d87fce5";
      };
    }

    {
      name = "npm-profile-3.0.2.tgz";
      path = fetchurl {
        name = "npm-profile-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/npm-profile/-/npm-profile-3.0.2.tgz";
        sha1 = "58d568f1b56ef769602fd0aed8c43fa0e0de0f57";
      };
    }

    {
      name = "npm-registry-client-8.6.0.tgz";
      path = fetchurl {
        name = "npm-registry-client-8.6.0.tgz";
        url  = "https://registry.yarnpkg.com/npm-registry-client/-/npm-registry-client-8.6.0.tgz";
        sha1 = "7f1529f91450732e89f8518e0f21459deea3e4c4";
      };
    }

    {
      name = "npm-registry-fetch-1.1.1.tgz";
      path = fetchurl {
        name = "npm-registry-fetch-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/npm-registry-fetch/-/npm-registry-fetch-1.1.1.tgz";
        sha1 = "710bc5947d9ee2c549375072dab6d5d17baf2eb2";
      };
    }

    {
      name = "npm-registry-fetch-3.8.0.tgz";
      path = fetchurl {
        name = "npm-registry-fetch-3.8.0.tgz";
        url  = "https://registry.yarnpkg.com/npm-registry-fetch/-/npm-registry-fetch-3.8.0.tgz";
        sha1 = "aa7d9a7c92aff94f48dba0984bdef4bd131c88cc";
      };
    }

    {
      name = "npm-run-path-2.0.2.tgz";
      path = fetchurl {
        name = "npm-run-path-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-2.0.2.tgz";
        sha1 = "35a9232dfa35d7067b4cb2ddf2357b1871536c5f";
      };
    }

    {
      name = "npm-user-validate-1.0.0.tgz";
      path = fetchurl {
        name = "npm-user-validate-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/npm-user-validate/-/npm-user-validate-1.0.0.tgz";
        sha1 = "8ceca0f5cea04d4e93519ef72d0557a75122e951";
      };
    }

    {
      name = "npm-6.4.1.tgz";
      path = fetchurl {
        name = "npm-6.4.1.tgz";
        url  = "https://registry.yarnpkg.com/npm/-/npm-6.4.1.tgz";
        sha1 = "4f39f9337b557a28faed4a771d5c8802d6b4288b";
      };
    }

    {
      name = "npmlog-4.1.2.tgz";
      path = fetchurl {
        name = "npmlog-4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/npmlog/-/npmlog-4.1.2.tgz";
        sha1 = "08a7f2a8bf734604779a9efa4ad5cc717abb954b";
      };
    }

    {
      name = "nth-check-1.0.1.tgz";
      path = fetchurl {
        name = "nth-check-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/nth-check/-/nth-check-1.0.1.tgz";
        sha1 = "9929acdf628fc2c41098deab82ac580cf149aae4";
      };
    }

    {
      name = "num2fraction-1.2.2.tgz";
      path = fetchurl {
        name = "num2fraction-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/num2fraction/-/num2fraction-1.2.2.tgz";
        sha1 = "6f682b6a027a4e9ddfa4564cd2589d1d4e669ede";
      };
    }

    {
      name = "number-is-nan-1.0.1.tgz";
      path = fetchurl {
        name = "number-is-nan-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz";
        sha1 = "097b602b53422a522c1afb8790318336941a011d";
      };
    }

    {
      name = "nwsapi-2.0.9.tgz";
      path = fetchurl {
        name = "nwsapi-2.0.9.tgz";
        url  = "https://registry.yarnpkg.com/nwsapi/-/nwsapi-2.0.9.tgz";
        sha1 = "77ac0cdfdcad52b6a1151a84e73254edc33ed016";
      };
    }

    {
      name = "oauth-sign-0.8.2.tgz";
      path = fetchurl {
        name = "oauth-sign-0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/oauth-sign/-/oauth-sign-0.8.2.tgz";
        sha1 = "46a6ab7f0aead8deae9ec0565780b7d4efeb9d43";
      };
    }

    {
      name = "oauth-sign-0.9.0.tgz";
      path = fetchurl {
        name = "oauth-sign-0.9.0.tgz";
        url  = "https://registry.yarnpkg.com/oauth-sign/-/oauth-sign-0.9.0.tgz";
        sha1 = "47a7b016baa68b5fa0ecf3dee08a85c679ac6455";
      };
    }

    {
      name = "object-assign-4.1.1.tgz";
      path = fetchurl {
        name = "object-assign-4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz";
        sha1 = "2109adc7965887cfc05cbbd442cac8bfbb360863";
      };
    }

    {
      name = "object-assign-2.1.1.tgz";
      path = fetchurl {
        name = "object-assign-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-assign/-/object-assign-2.1.1.tgz";
        sha1 = "43c36e5d569ff8e4816c4efa8be02d26967c18aa";
      };
    }

    {
      name = "object-component-0.0.3.tgz";
      path = fetchurl {
        name = "object-component-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/object-component/-/object-component-0.0.3.tgz";
        sha1 = "f0c69aa50efc95b866c186f400a33769cb2f1291";
      };
    }

    {
      name = "object-copy-0.1.0.tgz";
      path = fetchurl {
        name = "object-copy-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/object-copy/-/object-copy-0.1.0.tgz";
        sha1 = "7e7d858b781bd7c991a41ba975ed3812754e998c";
      };
    }

    {
      name = "object-keys-1.0.12.tgz";
      path = fetchurl {
        name = "object-keys-1.0.12.tgz";
        url  = "https://registry.yarnpkg.com/object-keys/-/object-keys-1.0.12.tgz";
        sha1 = "09c53855377575310cca62f55bb334abff7b3ed2";
      };
    }

    {
      name = "object-visit-1.0.1.tgz";
      path = fetchurl {
        name = "object-visit-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/object-visit/-/object-visit-1.0.1.tgz";
        sha1 = "f79c4493af0c5377b59fe39d395e41042dd045bb";
      };
    }

    {
      name = "object.getownpropertydescriptors-2.0.3.tgz";
      path = fetchurl {
        name = "object.getownpropertydescriptors-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/object.getownpropertydescriptors/-/object.getownpropertydescriptors-2.0.3.tgz";
        sha1 = "8758c846f5b407adab0f236e0986f14b051caa16";
      };
    }

    {
      name = "object.omit-2.0.1.tgz";
      path = fetchurl {
        name = "object.omit-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/object.omit/-/object.omit-2.0.1.tgz";
        sha1 = "1a9c744829f39dbb858c76ca3579ae2a54ebd1fa";
      };
    }

    {
      name = "object.pick-1.3.0.tgz";
      path = fetchurl {
        name = "object.pick-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/object.pick/-/object.pick-1.3.0.tgz";
        sha1 = "87a10ac4c1694bd2e1cbf53591a66141fb5dd747";
      };
    }

    {
      name = "on-finished-2.3.0.tgz";
      path = fetchurl {
        name = "on-finished-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/on-finished/-/on-finished-2.3.0.tgz";
        sha1 = "20f1336481b083cd75337992a16971aa2d906947";
      };
    }

    {
      name = "on-headers-1.0.1.tgz";
      path = fetchurl {
        name = "on-headers-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/on-headers/-/on-headers-1.0.1.tgz";
        sha1 = "928f5d0f470d49342651ea6794b0857c100693f7";
      };
    }

    {
      name = "once-1.4.0.tgz";
      path = fetchurl {
        name = "once-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/once/-/once-1.4.0.tgz";
        sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
      };
    }

    {
      name = "one-time-0.0.4.tgz";
      path = fetchurl {
        name = "one-time-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/one-time/-/one-time-0.0.4.tgz";
        sha1 = "f8cdf77884826fe4dff93e3a9cc37b1e4480742e";
      };
    }

    {
      name = "onetime-1.1.0.tgz";
      path = fetchurl {
        name = "onetime-1.1.0.tgz";
        url  = "http://registry.npmjs.org/onetime/-/onetime-1.1.0.tgz";
        sha1 = "a1f7838f8314c516f05ecefcbc4ccfe04b4ed789";
      };
    }

    {
      name = "onetime-2.0.1.tgz";
      path = fetchurl {
        name = "onetime-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/onetime/-/onetime-2.0.1.tgz";
        sha1 = "067428230fd67443b2794b22bba528b6867962d4";
      };
    }

    {
      name = "opener-1.5.1.tgz";
      path = fetchurl {
        name = "opener-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/opener/-/opener-1.5.1.tgz";
        sha1 = "6d2f0e77f1a0af0032aca716c2c1fbb8e7e8abed";
      };
    }

    {
      name = "optimist-0.6.1.tgz";
      path = fetchurl {
        name = "optimist-0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/optimist/-/optimist-0.6.1.tgz";
        sha1 = "da3ea74686fa21a19a111c326e90eb15a0196686";
      };
    }

    {
      name = "optionator-0.8.2.tgz";
      path = fetchurl {
        name = "optionator-0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/optionator/-/optionator-0.8.2.tgz";
        sha1 = "364c5e409d3f4d6301d6c0b4c05bba50180aeb64";
      };
    }

    {
      name = "ora-2.1.0.tgz";
      path = fetchurl {
        name = "ora-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ora/-/ora-2.1.0.tgz";
        sha1 = "6caf2830eb924941861ec53a173799e008b51e5b";
      };
    }

    {
      name = "os-browserify-0.3.0.tgz";
      path = fetchurl {
        name = "os-browserify-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/os-browserify/-/os-browserify-0.3.0.tgz";
        sha1 = "854373c7f5c2315914fc9bfc6bd8238fdda1ec27";
      };
    }

    {
      name = "os-homedir-1.0.2.tgz";
      path = fetchurl {
        name = "os-homedir-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/os-homedir/-/os-homedir-1.0.2.tgz";
        sha1 = "ffbc4988336e0e833de0c168c7ef152121aa7fb3";
      };
    }

    {
      name = "os-locale-1.4.0.tgz";
      path = fetchurl {
        name = "os-locale-1.4.0.tgz";
        url  = "http://registry.npmjs.org/os-locale/-/os-locale-1.4.0.tgz";
        sha1 = "20f9f17ae29ed345e8bde583b13d2009803c14d9";
      };
    }

    {
      name = "os-locale-2.1.0.tgz";
      path = fetchurl {
        name = "os-locale-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/os-locale/-/os-locale-2.1.0.tgz";
        sha1 = "42bc2900a6b5b8bd17376c8e882b65afccf24bf2";
      };
    }

    {
      name = "os-locale-3.0.1.tgz";
      path = fetchurl {
        name = "os-locale-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/os-locale/-/os-locale-3.0.1.tgz";
        sha1 = "3b014fbf01d87f60a1e5348d80fe870dc82c4620";
      };
    }

    {
      name = "os-shim-0.1.3.tgz";
      path = fetchurl {
        name = "os-shim-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/os-shim/-/os-shim-0.1.3.tgz";
        sha1 = "6b62c3791cf7909ea35ed46e17658bb417cb3917";
      };
    }

    {
      name = "os-tmpdir-1.0.2.tgz";
      path = fetchurl {
        name = "os-tmpdir-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz";
        sha1 = "bbe67406c79aa85c5cfec766fe5734555dfa1274";
      };
    }

    {
      name = "osenv-0.1.5.tgz";
      path = fetchurl {
        name = "osenv-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/osenv/-/osenv-0.1.5.tgz";
        sha1 = "85cdfafaeb28e8677f416e287592b5f3f49ea410";
      };
    }

    {
      name = "p-defer-1.0.0.tgz";
      path = fetchurl {
        name = "p-defer-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-defer/-/p-defer-1.0.0.tgz";
        sha1 = "9f6eb182f6c9aa8cd743004a7d4f96b196b0fb0c";
      };
    }

    {
      name = "p-filter-1.0.0.tgz";
      path = fetchurl {
        name = "p-filter-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-filter/-/p-filter-1.0.0.tgz";
        sha1 = "629d317150209c8fd508ba137713ef4bb920e9db";
      };
    }

    {
      name = "p-finally-1.0.0.tgz";
      path = fetchurl {
        name = "p-finally-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-finally/-/p-finally-1.0.0.tgz";
        sha1 = "3fbcfb15b899a44123b34b6dcc18b724336a2cae";
      };
    }

    {
      name = "p-is-promise-1.1.0.tgz";
      path = fetchurl {
        name = "p-is-promise-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/p-is-promise/-/p-is-promise-1.1.0.tgz";
        sha1 = "9c9456989e9f6588017b0434d56097675c3da05e";
      };
    }

    {
      name = "p-limit-1.3.0.tgz";
      path = fetchurl {
        name = "p-limit-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/p-limit/-/p-limit-1.3.0.tgz";
        sha1 = "b86bd5f0c25690911c7590fcbfc2010d54b3ccb8";
      };
    }

    {
      name = "p-limit-2.0.0.tgz";
      path = fetchurl {
        name = "p-limit-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-limit/-/p-limit-2.0.0.tgz";
        sha1 = "e624ed54ee8c460a778b3c9f3670496ff8a57aec";
      };
    }

    {
      name = "p-locate-2.0.0.tgz";
      path = fetchurl {
        name = "p-locate-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz";
        sha1 = "20a0103b222a70c8fd39cc2e580680f3dde5ec43";
      };
    }

    {
      name = "p-locate-3.0.0.tgz";
      path = fetchurl {
        name = "p-locate-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-locate/-/p-locate-3.0.0.tgz";
        sha1 = "322d69a05c0264b25997d9f40cd8a891ab0064a4";
      };
    }

    {
      name = "p-map-1.2.0.tgz";
      path = fetchurl {
        name = "p-map-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/p-map/-/p-map-1.2.0.tgz";
        sha1 = "e4e94f311eabbc8633a1e79908165fca26241b6b";
      };
    }

    {
      name = "p-reduce-1.0.0.tgz";
      path = fetchurl {
        name = "p-reduce-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-reduce/-/p-reduce-1.0.0.tgz";
        sha1 = "18c2b0dd936a4690a529f8231f58a0fdb6a47dfa";
      };
    }

    {
      name = "p-retry-2.0.0.tgz";
      path = fetchurl {
        name = "p-retry-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-retry/-/p-retry-2.0.0.tgz";
        sha1 = "b97f1f4d6d81a3c065b2b40107b811e995c1bfba";
      };
    }

    {
      name = "p-try-1.0.0.tgz";
      path = fetchurl {
        name = "p-try-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-try/-/p-try-1.0.0.tgz";
        sha1 = "cbc79cdbaf8fd4228e13f621f2b1a237c1b207b3";
      };
    }

    {
      name = "p-try-2.0.0.tgz";
      path = fetchurl {
        name = "p-try-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-try/-/p-try-2.0.0.tgz";
        sha1 = "85080bb87c64688fa47996fe8f7dfbe8211760b1";
      };
    }

    {
      name = "package-json-4.0.1.tgz";
      path = fetchurl {
        name = "package-json-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/package-json/-/package-json-4.0.1.tgz";
        sha1 = "8869a0401253661c4c4ca3da6c2121ed555f5eed";
      };
    }

    {
      name = "pacote-8.1.6.tgz";
      path = fetchurl {
        name = "pacote-8.1.6.tgz";
        url  = "https://registry.yarnpkg.com/pacote/-/pacote-8.1.6.tgz";
        sha1 = "8e647564d38156367e7a9dc47a79ca1ab278d46e";
      };
    }

    {
      name = "pako-1.0.6.tgz";
      path = fetchurl {
        name = "pako-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/pako/-/pako-1.0.6.tgz";
        sha1 = "0101211baa70c4bca4a0f63f2206e97b7dfaf258";
      };
    }

    {
      name = "parallel-transform-1.1.0.tgz";
      path = fetchurl {
        name = "parallel-transform-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/parallel-transform/-/parallel-transform-1.1.0.tgz";
        sha1 = "d410f065b05da23081fcd10f28854c29bda33b06";
      };
    }

    {
      name = "parse-asn1-5.1.1.tgz";
      path = fetchurl {
        name = "parse-asn1-5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/parse-asn1/-/parse-asn1-5.1.1.tgz";
        sha1 = "f6bf293818332bd0dab54efb16087724745e6ca8";
      };
    }

    {
      name = "parse-bmfont-ascii-1.0.6.tgz";
      path = fetchurl {
        name = "parse-bmfont-ascii-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/parse-bmfont-ascii/-/parse-bmfont-ascii-1.0.6.tgz";
        sha1 = "11ac3c3ff58f7c2020ab22769079108d4dfa0285";
      };
    }

    {
      name = "parse-bmfont-binary-1.0.6.tgz";
      path = fetchurl {
        name = "parse-bmfont-binary-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/parse-bmfont-binary/-/parse-bmfont-binary-1.0.6.tgz";
        sha1 = "d038b476d3e9dd9db1e11a0b0e53a22792b69006";
      };
    }

    {
      name = "parse-bmfont-xml-1.1.4.tgz";
      path = fetchurl {
        name = "parse-bmfont-xml-1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/parse-bmfont-xml/-/parse-bmfont-xml-1.1.4.tgz";
        sha1 = "015319797e3e12f9e739c4d513872cd2fa35f389";
      };
    }

    {
      name = "parse-github-url-1.0.2.tgz";
      path = fetchurl {
        name = "parse-github-url-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/parse-github-url/-/parse-github-url-1.0.2.tgz";
        sha1 = "242d3b65cbcdda14bb50439e3242acf6971db395";
      };
    }

    {
      name = "parse-glob-3.0.4.tgz";
      path = fetchurl {
        name = "parse-glob-3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/parse-glob/-/parse-glob-3.0.4.tgz";
        sha1 = "b2c376cfb11f35513badd173ef0bb6e3a388391c";
      };
    }

    {
      name = "parse-headers-2.0.1.tgz";
      path = fetchurl {
        name = "parse-headers-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/parse-headers/-/parse-headers-2.0.1.tgz";
        sha1 = "6ae83a7aa25a9d9b700acc28698cd1f1ed7e9536";
      };
    }

    {
      name = "parse-json-2.2.0.tgz";
      path = fetchurl {
        name = "parse-json-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/parse-json/-/parse-json-2.2.0.tgz";
        sha1 = "f480f40434ef80741f8469099f8dea18f55a4dc9";
      };
    }

    {
      name = "parse-json-4.0.0.tgz";
      path = fetchurl {
        name = "parse-json-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/parse-json/-/parse-json-4.0.0.tgz";
        sha1 = "be35f5425be1f7f6c747184f98a788cb99477ee0";
      };
    }

    {
      name = "parse-ms-1.0.1.tgz";
      path = fetchurl {
        name = "parse-ms-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/parse-ms/-/parse-ms-1.0.1.tgz";
        sha1 = "56346d4749d78f23430ca0c713850aef91aa361d";
      };
    }

    {
      name = "parse-passwd-1.0.0.tgz";
      path = fetchurl {
        name = "parse-passwd-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/parse-passwd/-/parse-passwd-1.0.0.tgz";
        sha1 = "6d5b934a456993b23d37f40a382d6f1666a8e5c6";
      };
    }

    {
      name = "parse-png-1.1.2.tgz";
      path = fetchurl {
        name = "parse-png-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/parse-png/-/parse-png-1.1.2.tgz";
        sha1 = "f5c2ad7c7993490986020a284c19aee459711ff2";
      };
    }

    {
      name = "parse-url-1.3.11.tgz";
      path = fetchurl {
        name = "parse-url-1.3.11.tgz";
        url  = "https://registry.yarnpkg.com/parse-url/-/parse-url-1.3.11.tgz";
        sha1 = "57c15428ab8a892b1f43869645c711d0e144b554";
      };
    }

    {
      name = "parse5-4.0.0.tgz";
      path = fetchurl {
        name = "parse5-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/parse5/-/parse5-4.0.0.tgz";
        sha1 = "6d78656e3da8d78b4ec0b906f7c08ef1dfe3f608";
      };
    }

    {
      name = "parseqs-0.0.5.tgz";
      path = fetchurl {
        name = "parseqs-0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/parseqs/-/parseqs-0.0.5.tgz";
        sha1 = "d5208a3738e46766e291ba2ea173684921a8b89d";
      };
    }

    {
      name = "parseuri-0.0.5.tgz";
      path = fetchurl {
        name = "parseuri-0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/parseuri/-/parseuri-0.0.5.tgz";
        sha1 = "80204a50d4dbb779bfdc6ebe2778d90e4bce320a";
      };
    }

    {
      name = "parseurl-1.3.2.tgz";
      path = fetchurl {
        name = "parseurl-1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/parseurl/-/parseurl-1.3.2.tgz";
        sha1 = "fc289d4ed8993119460c156253262cdc8de65bf3";
      };
    }

    {
      name = "pascalcase-0.1.1.tgz";
      path = fetchurl {
        name = "pascalcase-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/pascalcase/-/pascalcase-0.1.1.tgz";
        sha1 = "b363e55e8006ca6fe21784d2db22bd15d7917f14";
      };
    }

    {
      name = "passwd-user-1.2.1.tgz";
      path = fetchurl {
        name = "passwd-user-1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/passwd-user/-/passwd-user-1.2.1.tgz";
        sha1 = "a01a5dc639ef007dc56364b8178569080ad3a7b8";
      };
    }

    {
      name = "path-browserify-0.0.0.tgz";
      path = fetchurl {
        name = "path-browserify-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-browserify/-/path-browserify-0.0.0.tgz";
        sha1 = "a0b870729aae214005b7d5032ec2cbbb0fb4451a";
      };
    }

    {
      name = "path-dirname-1.0.2.tgz";
      path = fetchurl {
        name = "path-dirname-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/path-dirname/-/path-dirname-1.0.2.tgz";
        sha1 = "cc33d24d525e099a5388c0336c6e32b9160609e0";
      };
    }

    {
      name = "path-exists-2.1.0.tgz";
      path = fetchurl {
        name = "path-exists-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-2.1.0.tgz";
        sha1 = "0feb6c64f0fc518d9a754dd5efb62c7022761f4b";
      };
    }

    {
      name = "path-exists-3.0.0.tgz";
      path = fetchurl {
        name = "path-exists-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz";
        sha1 = "ce0ebeaa5f78cb18925ea7d810d7b59b010fd515";
      };
    }

    {
      name = "path-is-absolute-1.0.1.tgz";
      path = fetchurl {
        name = "path-is-absolute-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
      };
    }

    {
      name = "path-is-inside-1.0.2.tgz";
      path = fetchurl {
        name = "path-is-inside-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/path-is-inside/-/path-is-inside-1.0.2.tgz";
        sha1 = "365417dede44430d1c11af61027facf074bdfc53";
      };
    }

    {
      name = "path-key-2.0.1.tgz";
      path = fetchurl {
        name = "path-key-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz";
        sha1 = "411cadb574c5a140d3a4b1910d40d80cc9f40b40";
      };
    }

    {
      name = "path-parse-1.0.6.tgz";
      path = fetchurl {
        name = "path-parse-1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.6.tgz";
        sha1 = "d62dbb5679405d72c4737ec58600e9ddcf06d24c";
      };
    }

    {
      name = "path-posix-1.0.0.tgz";
      path = fetchurl {
        name = "path-posix-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-posix/-/path-posix-1.0.0.tgz";
        sha1 = "06b26113f56beab042545a23bfa88003ccac260f";
      };
    }

    {
      name = "path-to-regexp-0.1.7.tgz";
      path = fetchurl {
        name = "path-to-regexp-0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-0.1.7.tgz";
        sha1 = "df604178005f522f15eb4490e7247a1bfaa67f8c";
      };
    }

    {
      name = "path-to-regexp-1.7.0.tgz";
      path = fetchurl {
        name = "path-to-regexp-1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-1.7.0.tgz";
        sha1 = "59fde0f435badacba103a84e9d3bc64e96b9937d";
      };
    }

    {
      name = "path-type-1.1.0.tgz";
      path = fetchurl {
        name = "path-type-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/path-type/-/path-type-1.1.0.tgz";
        sha1 = "59c44f7ee491da704da415da5a4070ba4f8fe441";
      };
    }

    {
      name = "path-type-3.0.0.tgz";
      path = fetchurl {
        name = "path-type-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-type/-/path-type-3.0.0.tgz";
        sha1 = "cef31dc8e0a1a3bb0d105c0cd97cf3bf47f4e36f";
      };
    }

    {
      name = "pbkdf2-3.0.16.tgz";
      path = fetchurl {
        name = "pbkdf2-3.0.16.tgz";
        url  = "https://registry.yarnpkg.com/pbkdf2/-/pbkdf2-3.0.16.tgz";
        sha1 = "7404208ec6b01b62d85bf83853a8064f8d9c2a5c";
      };
    }

    {
      name = "pend-1.2.0.tgz";
      path = fetchurl {
        name = "pend-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz";
        sha1 = "7a57eb550a6783f9115331fcf4663d5c8e007a50";
      };
    }

    {
      name = "performance-now-2.1.0.tgz";
      path = fetchurl {
        name = "performance-now-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/performance-now/-/performance-now-2.1.0.tgz";
        sha1 = "6309f4e0e5fa913ec1c69307ae364b4b377c9e7b";
      };
    }

    {
      name = "phantomjs-prebuilt-2.1.16.tgz";
      path = fetchurl {
        name = "phantomjs-prebuilt-2.1.16.tgz";
        url  = "https://registry.yarnpkg.com/phantomjs-prebuilt/-/phantomjs-prebuilt-2.1.16.tgz";
        sha1 = "efd212a4a3966d3647684ea8ba788549be2aefef";
      };
    }

    {
      name = "phin-2.9.2.tgz";
      path = fetchurl {
        name = "phin-2.9.2.tgz";
        url  = "https://registry.yarnpkg.com/phin/-/phin-2.9.2.tgz";
        sha1 = "0a82d5b6dd75552b665f371f8060689c1af7336e";
      };
    }

    {
      name = "pify-2.3.0.tgz";
      path = fetchurl {
        name = "pify-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz";
        sha1 = "ed141a6ac043a849ea588498e7dca8b15330e90c";
      };
    }

    {
      name = "pify-3.0.0.tgz";
      path = fetchurl {
        name = "pify-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz";
        sha1 = "e5a4acd2c101fdf3d9a4d07f0dbc4db49dd28176";
      };
    }

    {
      name = "pinkie-promise-2.0.1.tgz";
      path = fetchurl {
        name = "pinkie-promise-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz";
        sha1 = "2135d6dfa7a358c069ac9b178776288228450ffa";
      };
    }

    {
      name = "pinkie-2.0.4.tgz";
      path = fetchurl {
        name = "pinkie-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz";
        sha1 = "72556b80cfa0d48a974e80e77248e80ed4f7f870";
      };
    }

    {
      name = "pixelmatch-4.0.2.tgz";
      path = fetchurl {
        name = "pixelmatch-4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pixelmatch/-/pixelmatch-4.0.2.tgz";
        sha1 = "8f47dcec5011b477b67db03c243bc1f3085e8854";
      };
    }

    {
      name = "pkg-conf-2.1.0.tgz";
      path = fetchurl {
        name = "pkg-conf-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/pkg-conf/-/pkg-conf-2.1.0.tgz";
        sha1 = "2126514ca6f2abfebd168596df18ba57867f0058";
      };
    }

    {
      name = "pkg-dir-2.0.0.tgz";
      path = fetchurl {
        name = "pkg-dir-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-2.0.0.tgz";
        sha1 = "f6d5d1109e19d63edf428e0bd57e12777615334b";
      };
    }

    {
      name = "pkg-up-2.0.0.tgz";
      path = fetchurl {
        name = "pkg-up-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pkg-up/-/pkg-up-2.0.0.tgz";
        sha1 = "c819ac728059a461cab1c3889a2be3c49a004d7f";
      };
    }

    {
      name = "pluralize-7.0.0.tgz";
      path = fetchurl {
        name = "pluralize-7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pluralize/-/pluralize-7.0.0.tgz";
        sha1 = "298b89df8b93b0221dbf421ad2b1b1ea23fc6777";
      };
    }

    {
      name = "pn-1.1.0.tgz";
      path = fetchurl {
        name = "pn-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/pn/-/pn-1.1.0.tgz";
        sha1 = "e2f4cef0e219f463c179ab37463e4e1ecdccbafb";
      };
    }

    {
      name = "pngjs-3.3.3.tgz";
      path = fetchurl {
        name = "pngjs-3.3.3.tgz";
        url  = "https://registry.yarnpkg.com/pngjs/-/pngjs-3.3.3.tgz";
        sha1 = "85173703bde3edac8998757b96e5821d0966a21b";
      };
    }

    {
      name = "portfinder-1.0.17.tgz";
      path = fetchurl {
        name = "portfinder-1.0.17.tgz";
        url  = "https://registry.yarnpkg.com/portfinder/-/portfinder-1.0.17.tgz";
        sha1 = "a8a1691143e46c4735edefcf4fbcccedad26456a";
      };
    }

    {
      name = "posix-character-classes-0.1.1.tgz";
      path = fetchurl {
        name = "posix-character-classes-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/posix-character-classes/-/posix-character-classes-0.1.1.tgz";
        sha1 = "01eac0fe3b5af71a2a6c02feabb8c1fef7e00eab";
      };
    }

    {
      name = "postcss-value-parser-3.3.0.tgz";
      path = fetchurl {
        name = "postcss-value-parser-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-3.3.0.tgz";
        sha1 = "87f38f9f18f774a4ab4c8a232f5c5ce8872a9d15";
      };
    }

    {
      name = "postcss-6.0.23.tgz";
      path = fetchurl {
        name = "postcss-6.0.23.tgz";
        url  = "https://registry.yarnpkg.com/postcss/-/postcss-6.0.23.tgz";
        sha1 = "61c82cc328ac60e677645f979054eb98bc0e3324";
      };
    }

    {
      name = "prelude-ls-1.1.2.tgz";
      path = fetchurl {
        name = "prelude-ls-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.1.2.tgz";
        sha1 = "21932a549f5e52ffd9a827f570e04be62a97da54";
      };
    }

    {
      name = "prepend-http-1.0.4.tgz";
      path = fetchurl {
        name = "prepend-http-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/prepend-http/-/prepend-http-1.0.4.tgz";
        sha1 = "d4f4562b0ce3696e41ac52d0e002e57a635dc6dc";
      };
    }

    {
      name = "preserve-0.2.0.tgz";
      path = fetchurl {
        name = "preserve-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/preserve/-/preserve-0.2.0.tgz";
        sha1 = "815ed1f6ebc65926f865b310c0713bcb3315ce4b";
      };
    }

    {
      name = "pretender-1.6.1.tgz";
      path = fetchurl {
        name = "pretender-1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/pretender/-/pretender-1.6.1.tgz";
        sha1 = "77d1e42ac8c6b298f5cd43534a87645df035db8c";
      };
    }

    {
      name = "prettier-eslint-cli-4.7.1.tgz";
      path = fetchurl {
        name = "prettier-eslint-cli-4.7.1.tgz";
        url  = "https://registry.yarnpkg.com/prettier-eslint-cli/-/prettier-eslint-cli-4.7.1.tgz";
        sha1 = "3d103c494baa4e80b99ad53e2b9db7620101859f";
      };
    }

    {
      name = "prettier-eslint-8.8.2.tgz";
      path = fetchurl {
        name = "prettier-eslint-8.8.2.tgz";
        url  = "https://registry.yarnpkg.com/prettier-eslint/-/prettier-eslint-8.8.2.tgz";
        sha1 = "fcb29a48ab4524e234680797fe70e9d136ccaf0b";
      };
    }

    {
      name = "prettier-1.14.3.tgz";
      path = fetchurl {
        name = "prettier-1.14.3.tgz";
        url  = "https://registry.yarnpkg.com/prettier/-/prettier-1.14.3.tgz";
        sha1 = "90238dd4c0684b7edce5f83b0fb7328e48bd0895";
      };
    }

    {
      name = "prettier-1.14.2.tgz";
      path = fetchurl {
        name = "prettier-1.14.2.tgz";
        url  = "https://registry.yarnpkg.com/prettier/-/prettier-1.14.2.tgz";
        sha1 = "0ac1c6e1a90baa22a62925f41963c841983282f9";
      };
    }

    {
      name = "pretty-format-23.5.0.tgz";
      path = fetchurl {
        name = "pretty-format-23.5.0.tgz";
        url  = "https://registry.yarnpkg.com/pretty-format/-/pretty-format-23.5.0.tgz";
        sha1 = "0f9601ad9da70fe690a269cd3efca732c210687c";
      };
    }

    {
      name = "pretty-ms-3.2.0.tgz";
      path = fetchurl {
        name = "pretty-ms-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pretty-ms/-/pretty-ms-3.2.0.tgz";
        sha1 = "87a8feaf27fc18414d75441467d411d6e6098a25";
      };
    }

    {
      name = "printf-0.5.1.tgz";
      path = fetchurl {
        name = "printf-0.5.1.tgz";
        url  = "https://registry.yarnpkg.com/printf/-/printf-0.5.1.tgz";
        sha1 = "e0466788260859ed153006dc6867f09ddf240cf3";
      };
    }

    {
      name = "private-0.1.8.tgz";
      path = fetchurl {
        name = "private-0.1.8.tgz";
        url  = "https://registry.yarnpkg.com/private/-/private-0.1.8.tgz";
        sha1 = "2381edb3689f7a53d653190060fcf822d2f368ff";
      };
    }

    {
      name = "process-nextick-args-2.0.0.tgz";
      path = fetchurl {
        name = "process-nextick-args-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.0.tgz";
        sha1 = "a37d732f4271b4ab1ad070d35508e8290788ffaa";
      };
    }

    {
      name = "process-relative-require-1.0.0.tgz";
      path = fetchurl {
        name = "process-relative-require-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/process-relative-require/-/process-relative-require-1.0.0.tgz";
        sha1 = "1590dfcf5b8f2983ba53e398446b68240b4cc68a";
      };
    }

    {
      name = "process-0.11.10.tgz";
      path = fetchurl {
        name = "process-0.11.10.tgz";
        url  = "https://registry.yarnpkg.com/process/-/process-0.11.10.tgz";
        sha1 = "7332300e840161bda3e69a1d1d91a7d4bc16f182";
      };
    }

    {
      name = "process-0.5.2.tgz";
      path = fetchurl {
        name = "process-0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/process/-/process-0.5.2.tgz";
        sha1 = "1638d8a8e34c2f440a91db95ab9aeb677fc185cf";
      };
    }

    {
      name = "progress-1.1.8.tgz";
      path = fetchurl {
        name = "progress-1.1.8.tgz";
        url  = "https://registry.yarnpkg.com/progress/-/progress-1.1.8.tgz";
        sha1 = "e260c78f6161cdd9b0e56cc3e0a85de17c7a57be";
      };
    }

    {
      name = "progress-2.0.0.tgz";
      path = fetchurl {
        name = "progress-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/progress/-/progress-2.0.0.tgz";
        sha1 = "8a1be366bf8fc23db2bd23f10c6fe920b4389d1f";
      };
    }

    {
      name = "promise-inflight-1.0.1.tgz";
      path = fetchurl {
        name = "promise-inflight-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/promise-inflight/-/promise-inflight-1.0.1.tgz";
        sha1 = "98472870bf228132fcbdd868129bad12c3c029e3";
      };
    }

    {
      name = "promise-map-series-0.2.3.tgz";
      path = fetchurl {
        name = "promise-map-series-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/promise-map-series/-/promise-map-series-0.2.3.tgz";
        sha1 = "c2d377afc93253f6bd03dbb77755eb88ab20a847";
      };
    }

    {
      name = "promise-retry-1.1.1.tgz";
      path = fetchurl {
        name = "promise-retry-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/promise-retry/-/promise-retry-1.1.1.tgz";
        sha1 = "6739e968e3051da20ce6497fb2b50f6911df3d6d";
      };
    }

    {
      name = "promised-io-0.3.5.tgz";
      path = fetchurl {
        name = "promised-io-0.3.5.tgz";
        url  = "https://registry.yarnpkg.com/promised-io/-/promised-io-0.3.5.tgz";
        sha1 = "4ad217bb3658bcaae9946b17a8668ecd851e1356";
      };
    }

    {
      name = "promzard-0.3.0.tgz";
      path = fetchurl {
        name = "promzard-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/promzard/-/promzard-0.3.0.tgz";
        sha1 = "26a5d6ee8c7dee4cb12208305acfb93ba382a9ee";
      };
    }

    {
      name = "proto-list-1.2.4.tgz";
      path = fetchurl {
        name = "proto-list-1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/proto-list/-/proto-list-1.2.4.tgz";
        sha1 = "212d5bfe1318306a420f6402b8e26ff39647a849";
      };
    }

    {
      name = "protocols-1.4.6.tgz";
      path = fetchurl {
        name = "protocols-1.4.6.tgz";
        url  = "https://registry.yarnpkg.com/protocols/-/protocols-1.4.6.tgz";
        sha1 = "f8bb263ea1b5fd7a7604d26b8be39bd77678bf8a";
      };
    }

    {
      name = "protoduck-5.0.0.tgz";
      path = fetchurl {
        name = "protoduck-5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/protoduck/-/protoduck-5.0.0.tgz";
        sha1 = "752145e6be0ad834cb25716f670a713c860dce70";
      };
    }

    {
      name = "proxy-addr-2.0.4.tgz";
      path = fetchurl {
        name = "proxy-addr-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/proxy-addr/-/proxy-addr-2.0.4.tgz";
        sha1 = "ecfc733bf22ff8c6f407fa275327b9ab67e48b93";
      };
    }

    {
      name = "prr-1.0.1.tgz";
      path = fetchurl {
        name = "prr-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/prr/-/prr-1.0.1.tgz";
        sha1 = "d3fc114ba06995a45ec6893f484ceb1d78f5f476";
      };
    }

    {
      name = "pseudomap-1.0.2.tgz";
      path = fetchurl {
        name = "pseudomap-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pseudomap/-/pseudomap-1.0.2.tgz";
        sha1 = "f052a28da70e618917ef0a8ac34c1ae5a68286b3";
      };
    }

    {
      name = "psl-1.1.29.tgz";
      path = fetchurl {
        name = "psl-1.1.29.tgz";
        url  = "https://registry.yarnpkg.com/psl/-/psl-1.1.29.tgz";
        sha1 = "60f580d360170bb722a797cc704411e6da850c67";
      };
    }

    {
      name = "public-encrypt-4.0.2.tgz";
      path = fetchurl {
        name = "public-encrypt-4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/public-encrypt/-/public-encrypt-4.0.2.tgz";
        sha1 = "46eb9107206bf73489f8b85b69d91334c6610994";
      };
    }

    {
      name = "pump-2.0.1.tgz";
      path = fetchurl {
        name = "pump-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/pump/-/pump-2.0.1.tgz";
        sha1 = "12399add6e4cf7526d973cbc8b5ce2e2908b3909";
      };
    }

    {
      name = "pump-3.0.0.tgz";
      path = fetchurl {
        name = "pump-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz";
        sha1 = "b4a2116815bde2f4e1ea602354e8c75565107a64";
      };
    }

    {
      name = "pumpify-1.5.1.tgz";
      path = fetchurl {
        name = "pumpify-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/pumpify/-/pumpify-1.5.1.tgz";
        sha1 = "36513be246ab27570b1a374a5ce278bfd74370ce";
      };
    }

    {
      name = "punycode-1.3.2.tgz";
      path = fetchurl {
        name = "punycode-1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-1.3.2.tgz";
        sha1 = "9653a036fb7c1ee42342f2325cceefea3926c48d";
      };
    }

    {
      name = "punycode-1.4.1.tgz";
      path = fetchurl {
        name = "punycode-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-1.4.1.tgz";
        sha1 = "c0d5a63b2718800ad8e1eb0fa5269c84dd41845e";
      };
    }

    {
      name = "punycode-2.1.1.tgz";
      path = fetchurl {
        name = "punycode-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-2.1.1.tgz";
        sha1 = "b58b010ac40c22c5657616c8d2c2c02c7bf479ec";
      };
    }

    {
      name = "q-1.5.1.tgz";
      path = fetchurl {
        name = "q-1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/q/-/q-1.5.1.tgz";
        sha1 = "7e32f75b41381291d04611f1bf14109ac00651d7";
      };
    }

    {
      name = "qrcode-terminal-0.12.0.tgz";
      path = fetchurl {
        name = "qrcode-terminal-0.12.0.tgz";
        url  = "https://registry.yarnpkg.com/qrcode-terminal/-/qrcode-terminal-0.12.0.tgz";
        sha1 = "bb5b699ef7f9f0505092a3748be4464fe71b5819";
      };
    }

    {
      name = "qs-6.5.1.tgz";
      path = fetchurl {
        name = "qs-6.5.1.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.5.1.tgz";
        sha1 = "349cdf6eef89ec45c12d7d5eb3fc0c870343a6d8";
      };
    }

    {
      name = "qs-6.5.2.tgz";
      path = fetchurl {
        name = "qs-6.5.2.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.5.2.tgz";
        sha1 = "cb3ae806e8740444584ef154ce8ee98d403f3e36";
      };
    }

    {
      name = "query-string-6.1.0.tgz";
      path = fetchurl {
        name = "query-string-6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/query-string/-/query-string-6.1.0.tgz";
        sha1 = "01e7d69f6a0940dac67a937d6c6325647aa4532a";
      };
    }

    {
      name = "querystring-es3-0.2.1.tgz";
      path = fetchurl {
        name = "querystring-es3-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/querystring-es3/-/querystring-es3-0.2.1.tgz";
        sha1 = "9ec61f79049875707d69414596fd907a4d711e73";
      };
    }

    {
      name = "querystring-0.2.0.tgz";
      path = fetchurl {
        name = "querystring-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/querystring/-/querystring-0.2.0.tgz";
        sha1 = "b209849203bb25df820da756e747005878521620";
      };
    }

    {
      name = "quick-lru-1.1.0.tgz";
      path = fetchurl {
        name = "quick-lru-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/quick-lru/-/quick-lru-1.1.0.tgz";
        sha1 = "4360b17c61136ad38078397ff11416e186dcfbb8";
      };
    }

    {
      name = "quick-temp-0.1.8.tgz";
      path = fetchurl {
        name = "quick-temp-0.1.8.tgz";
        url  = "https://registry.yarnpkg.com/quick-temp/-/quick-temp-0.1.8.tgz";
        sha1 = "bab02a242ab8fb0dd758a3c9776b32f9a5d94408";
      };
    }

    {
      name = "qunit-dom-0.7.1.tgz";
      path = fetchurl {
        name = "qunit-dom-0.7.1.tgz";
        url  = "https://registry.yarnpkg.com/qunit-dom/-/qunit-dom-0.7.1.tgz";
        sha1 = "2e6ad4a6453c034f88ef415250b37e82572460b9";
      };
    }

    {
      name = "qunit-2.6.2.tgz";
      path = fetchurl {
        name = "qunit-2.6.2.tgz";
        url  = "https://registry.yarnpkg.com/qunit/-/qunit-2.6.2.tgz";
        sha1 = "551210c5cf857258a4fe39a7fe15d9e14dfef22c";
      };
    }

    {
      name = "qw-1.0.1.tgz";
      path = fetchurl {
        name = "qw-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/qw/-/qw-1.0.1.tgz";
        sha1 = "efbfdc740f9ad054304426acb183412cc8b996d4";
      };
    }

    {
      name = "randomatic-3.1.0.tgz";
      path = fetchurl {
        name = "randomatic-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/randomatic/-/randomatic-3.1.0.tgz";
        sha1 = "36f2ca708e9e567f5ed2ec01949026d50aa10116";
      };
    }

    {
      name = "randombytes-2.0.6.tgz";
      path = fetchurl {
        name = "randombytes-2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/randombytes/-/randombytes-2.0.6.tgz";
        sha1 = "d302c522948588848a8d300c932b44c24231da80";
      };
    }

    {
      name = "randomfill-1.0.4.tgz";
      path = fetchurl {
        name = "randomfill-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/randomfill/-/randomfill-1.0.4.tgz";
        sha1 = "c92196fc86ab42be983f1bf31778224931d61458";
      };
    }

    {
      name = "range-parser-1.2.0.tgz";
      path = fetchurl {
        name = "range-parser-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/range-parser/-/range-parser-1.2.0.tgz";
        sha1 = "f49be6b487894ddc40dcc94a322f611092e00d5e";
      };
    }

    {
      name = "raw-body-2.3.2.tgz";
      path = fetchurl {
        name = "raw-body-2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/raw-body/-/raw-body-2.3.2.tgz";
        sha1 = "bcd60c77d3eb93cde0050295c3f379389bc88f89";
      };
    }

    {
      name = "raw-body-2.3.3.tgz";
      path = fetchurl {
        name = "raw-body-2.3.3.tgz";
        url  = "https://registry.yarnpkg.com/raw-body/-/raw-body-2.3.3.tgz";
        sha1 = "1b324ece6b5706e153855bc1148c65bb7f6ea0c3";
      };
    }

    {
      name = "raw-body-1.1.7.tgz";
      path = fetchurl {
        name = "raw-body-1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/raw-body/-/raw-body-1.1.7.tgz";
        sha1 = "1d027c2bfa116acc6623bca8f00016572a87d425";
      };
    }

    {
      name = "rc-1.2.8.tgz";
      path = fetchurl {
        name = "rc-1.2.8.tgz";
        url  = "https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz";
        sha1 = "cd924bf5200a075b83c188cd6b9e211b7fc0d3ed";
      };
    }

    {
      name = "read-chunk-1.0.1.tgz";
      path = fetchurl {
        name = "read-chunk-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/read-chunk/-/read-chunk-1.0.1.tgz";
        sha1 = "5f68cab307e663f19993527d9b589cace4661194";
      };
    }

    {
      name = "read-cmd-shim-1.0.1.tgz";
      path = fetchurl {
        name = "read-cmd-shim-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/read-cmd-shim/-/read-cmd-shim-1.0.1.tgz";
        sha1 = "2d5d157786a37c055d22077c32c53f8329e91c7b";
      };
    }

    {
      name = "read-installed-4.0.3.tgz";
      path = fetchurl {
        name = "read-installed-4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/read-installed/-/read-installed-4.0.3.tgz";
        sha1 = "ff9b8b67f187d1e4c29b9feb31f6b223acd19067";
      };
    }

    {
      name = "read-package-json-2.0.13.tgz";
      path = fetchurl {
        name = "read-package-json-2.0.13.tgz";
        url  = "https://registry.yarnpkg.com/read-package-json/-/read-package-json-2.0.13.tgz";
        sha1 = "2e82ebd9f613baa6d2ebe3aa72cefe3f68e41f4a";
      };
    }

    {
      name = "read-package-tree-5.2.1.tgz";
      path = fetchurl {
        name = "read-package-tree-5.2.1.tgz";
        url  = "https://registry.yarnpkg.com/read-package-tree/-/read-package-tree-5.2.1.tgz";
        sha1 = "6218b187d6fac82289ce4387bbbaf8eef536ad63";
      };
    }

    {
      name = "read-pkg-up-1.0.1.tgz";
      path = fetchurl {
        name = "read-pkg-up-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-1.0.1.tgz";
        sha1 = "9d63c13276c065918d57f002a57f40a1b643fb02";
      };
    }

    {
      name = "read-pkg-up-3.0.0.tgz";
      path = fetchurl {
        name = "read-pkg-up-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-3.0.0.tgz";
        sha1 = "3ed496685dba0f8fe118d0691dc51f4a1ff96f07";
      };
    }

    {
      name = "read-pkg-up-4.0.0.tgz";
      path = fetchurl {
        name = "read-pkg-up-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-4.0.0.tgz";
        sha1 = "1b221c6088ba7799601c808f91161c66e58f8978";
      };
    }

    {
      name = "read-pkg-1.1.0.tgz";
      path = fetchurl {
        name = "read-pkg-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg/-/read-pkg-1.1.0.tgz";
        sha1 = "f5ffaa5ecd29cb31c0474bca7d756b6bb29e3f28";
      };
    }

    {
      name = "read-pkg-3.0.0.tgz";
      path = fetchurl {
        name = "read-pkg-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg/-/read-pkg-3.0.0.tgz";
        sha1 = "9cbc686978fee65d16c00e2b19c237fcf6e38389";
      };
    }

    {
      name = "read-pkg-4.0.1.tgz";
      path = fetchurl {
        name = "read-pkg-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg/-/read-pkg-4.0.1.tgz";
        sha1 = "963625378f3e1c4d48c85872b5a6ec7d5d093237";
      };
    }

    {
      name = "read-1.0.7.tgz";
      path = fetchurl {
        name = "read-1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/read/-/read-1.0.7.tgz";
        sha1 = "b3da19bd052431a97671d44a42634adf710b40c4";
      };
    }

    {
      name = "readable-stream-2.3.6.tgz";
      path = fetchurl {
        name = "readable-stream-2.3.6.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.6.tgz";
        sha1 = "b11c27d88b8ff1fbe070643cf94b0c79ae1b0aaf";
      };
    }

    {
      name = "readable-stream-1.1.13.tgz";
      path = fetchurl {
        name = "readable-stream-1.1.13.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.1.13.tgz";
        sha1 = "f6eef764f514c89e2b9e23146a75ba106756d23e";
      };
    }

    {
      name = "readable-stream-1.0.34.tgz";
      path = fetchurl {
        name = "readable-stream-1.0.34.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.0.34.tgz";
        sha1 = "125820e34bc842d2f2aaafafe4c2916ee32c157c";
      };
    }

    {
      name = "readable-stream-1.1.14.tgz";
      path = fetchurl {
        name = "readable-stream-1.1.14.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.1.14.tgz";
        sha1 = "7cf4c54ef648e3813084c636dd2079e166c081d9";
      };
    }

    {
      name = "readdir-scoped-modules-1.0.2.tgz";
      path = fetchurl {
        name = "readdir-scoped-modules-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/readdir-scoped-modules/-/readdir-scoped-modules-1.0.2.tgz";
        sha1 = "9fafa37d286be5d92cbaebdee030dc9b5f406747";
      };
    }

    {
      name = "readdirp-2.1.0.tgz";
      path = fetchurl {
        name = "readdirp-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/readdirp/-/readdirp-2.1.0.tgz";
        sha1 = "4ed0ad060df3073300c48440373f72d1cc642d78";
      };
    }

    {
      name = "recast-0.11.23.tgz";
      path = fetchurl {
        name = "recast-0.11.23.tgz";
        url  = "https://registry.yarnpkg.com/recast/-/recast-0.11.23.tgz";
        sha1 = "451fd3004ab1e4df9b4e4b66376b2a21912462d3";
      };
    }

    {
      name = "redent-1.0.0.tgz";
      path = fetchurl {
        name = "redent-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/redent/-/redent-1.0.0.tgz";
        sha1 = "cf916ab1fd5f1f16dfb20822dd6ec7f730c2afde";
      };
    }

    {
      name = "redent-2.0.0.tgz";
      path = fetchurl {
        name = "redent-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/redent/-/redent-2.0.0.tgz";
        sha1 = "c1b2007b42d57eb1389079b3c8333639d5e1ccaa";
      };
    }

    {
      name = "redeyed-1.0.1.tgz";
      path = fetchurl {
        name = "redeyed-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/redeyed/-/redeyed-1.0.1.tgz";
        sha1 = "e96c193b40c0816b00aec842698e61185e55498a";
      };
    }

    {
      name = "redeyed-2.1.1.tgz";
      path = fetchurl {
        name = "redeyed-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/redeyed/-/redeyed-2.1.1.tgz";
        sha1 = "8984b5815d99cb220469c99eeeffe38913e6cc0b";
      };
    }

    {
      name = "regenerate-1.4.0.tgz";
      path = fetchurl {
        name = "regenerate-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/regenerate/-/regenerate-1.4.0.tgz";
        sha1 = "4a856ec4b56e4077c557589cae85e7a4c8869a11";
      };
    }

    {
      name = "regenerator-runtime-0.10.5.tgz";
      path = fetchurl {
        name = "regenerator-runtime-0.10.5.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.10.5.tgz";
        sha1 = "336c3efc1220adcedda2c9fab67b5a7955a33658";
      };
    }

    {
      name = "regenerator-runtime-0.11.1.tgz";
      path = fetchurl {
        name = "regenerator-runtime-0.11.1.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz";
        sha1 = "be05ad7f9bf7d22e056f9726cee5017fbf19e2e9";
      };
    }

    {
      name = "regenerator-runtime-0.9.6.tgz";
      path = fetchurl {
        name = "regenerator-runtime-0.9.6.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.9.6.tgz";
        sha1 = "d33eb95d0d2001a4be39659707c51b0cb71ce029";
      };
    }

    {
      name = "regenerator-transform-0.10.1.tgz";
      path = fetchurl {
        name = "regenerator-transform-0.10.1.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-transform/-/regenerator-transform-0.10.1.tgz";
        sha1 = "1e4996837231da8b7f3cf4114d71b5691a0680dd";
      };
    }

    {
      name = "regex-cache-0.4.4.tgz";
      path = fetchurl {
        name = "regex-cache-0.4.4.tgz";
        url  = "https://registry.yarnpkg.com/regex-cache/-/regex-cache-0.4.4.tgz";
        sha1 = "75bdc58a2a1496cec48a12835bc54c8d562336dd";
      };
    }

    {
      name = "regex-not-1.0.2.tgz";
      path = fetchurl {
        name = "regex-not-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/regex-not/-/regex-not-1.0.2.tgz";
        sha1 = "1f4ece27e00b0b65e0247a6810e6a85d83a5752c";
      };
    }

    {
      name = "regexpp-1.1.0.tgz";
      path = fetchurl {
        name = "regexpp-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/regexpp/-/regexpp-1.1.0.tgz";
        sha1 = "0e3516dd0b7904f413d2d4193dce4618c3a689ab";
      };
    }

    {
      name = "regexpu-core-2.0.0.tgz";
      path = fetchurl {
        name = "regexpu-core-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-2.0.0.tgz";
        sha1 = "49d038837b8dcf8bfa5b9a42139938e6ea2ae240";
      };
    }

    {
      name = "registry-auth-token-3.3.2.tgz";
      path = fetchurl {
        name = "registry-auth-token-3.3.2.tgz";
        url  = "https://registry.yarnpkg.com/registry-auth-token/-/registry-auth-token-3.3.2.tgz";
        sha1 = "851fd49038eecb586911115af845260eec983f20";
      };
    }

    {
      name = "registry-url-3.1.0.tgz";
      path = fetchurl {
        name = "registry-url-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/registry-url/-/registry-url-3.1.0.tgz";
        sha1 = "3d4ef870f73dde1d77f0cf9a381432444e174942";
      };
    }

    {
      name = "regjsgen-0.2.0.tgz";
      path = fetchurl {
        name = "regjsgen-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/regjsgen/-/regjsgen-0.2.0.tgz";
        sha1 = "6c016adeac554f75823fe37ac05b92d5a4edb1f7";
      };
    }

    {
      name = "regjsparser-0.1.5.tgz";
      path = fetchurl {
        name = "regjsparser-0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.1.5.tgz";
        sha1 = "7ee8f84dc6fa792d3fd0ae228d24bd949ead205c";
      };
    }

    {
      name = "remove-trailing-separator-1.1.0.tgz";
      path = fetchurl {
        name = "remove-trailing-separator-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz";
        sha1 = "c24bce2a283adad5bc3f58e0d48249b92379d8ef";
      };
    }

    {
      name = "repeat-element-1.1.3.tgz";
      path = fetchurl {
        name = "repeat-element-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/repeat-element/-/repeat-element-1.1.3.tgz";
        sha1 = "782e0d825c0c5a3bb39731f84efee6b742e6b1ce";
      };
    }

    {
      name = "repeat-string-1.6.1.tgz";
      path = fetchurl {
        name = "repeat-string-1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz";
        sha1 = "8dcae470e1c88abc2d600fff4a776286da75e637";
      };
    }

    {
      name = "repeating-2.0.1.tgz";
      path = fetchurl {
        name = "repeating-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/repeating/-/repeating-2.0.1.tgz";
        sha1 = "5214c53a926d3552707527fbab415dbc08d06dda";
      };
    }

    {
      name = "replace-ext-0.0.1.tgz";
      path = fetchurl {
        name = "replace-ext-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/replace-ext/-/replace-ext-0.0.1.tgz";
        sha1 = "29bbd92078a739f0bcce2b4ee41e837953522924";
      };
    }

    {
      name = "request-progress-2.0.1.tgz";
      path = fetchurl {
        name = "request-progress-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/request-progress/-/request-progress-2.0.1.tgz";
        sha1 = "5d36bb57961c673aa5b788dbc8141fdf23b44e08";
      };
    }

    {
      name = "request-promise-core-1.1.1.tgz";
      path = fetchurl {
        name = "request-promise-core-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/request-promise-core/-/request-promise-core-1.1.1.tgz";
        sha1 = "3eee00b2c5aa83239cfb04c5700da36f81cd08b6";
      };
    }

    {
      name = "request-promise-native-1.0.5.tgz";
      path = fetchurl {
        name = "request-promise-native-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/request-promise-native/-/request-promise-native-1.0.5.tgz";
        sha1 = "5281770f68e0c9719e5163fd3fab482215f4fda5";
      };
    }

    {
      name = "request-2.87.0.tgz";
      path = fetchurl {
        name = "request-2.87.0.tgz";
        url  = "https://registry.yarnpkg.com/request/-/request-2.87.0.tgz";
        sha1 = "32f00235cd08d482b4d0d68db93a829c0ed5756e";
      };
    }

    {
      name = "request-2.88.0.tgz";
      path = fetchurl {
        name = "request-2.88.0.tgz";
        url  = "https://registry.yarnpkg.com/request/-/request-2.88.0.tgz";
        sha1 = "9c2fca4f7d35b592efe57c7f0a55e81052124fef";
      };
    }

    {
      name = "require-directory-2.1.1.tgz";
      path = fetchurl {
        name = "require-directory-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz";
        sha1 = "8c64ad5fd30dab1c976e2344ffe7f792a6a6df42";
      };
    }

    {
      name = "require-main-filename-1.0.1.tgz";
      path = fetchurl {
        name = "require-main-filename-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-1.0.1.tgz";
        sha1 = "97f717b69d48784f5f526a6c5aa8ffdda055a4d1";
      };
    }

    {
      name = "require-relative-0.8.7.tgz";
      path = fetchurl {
        name = "require-relative-0.8.7.tgz";
        url  = "https://registry.yarnpkg.com/require-relative/-/require-relative-0.8.7.tgz";
        sha1 = "7999539fc9e047a37928fa196f8e1563dabd36de";
      };
    }

    {
      name = "require-uncached-1.0.3.tgz";
      path = fetchurl {
        name = "require-uncached-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/require-uncached/-/require-uncached-1.0.3.tgz";
        sha1 = "4e0d56d6c9662fd31e43011c4b95aa49955421d3";
      };
    }

    {
      name = "requires-port-1.0.0.tgz";
      path = fetchurl {
        name = "requires-port-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/requires-port/-/requires-port-1.0.0.tgz";
        sha1 = "925d2601d39ac485e091cf0da5c6e694dc3dcaff";
      };
    }

    {
      name = "reserved-words-0.1.2.tgz";
      path = fetchurl {
        name = "reserved-words-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/reserved-words/-/reserved-words-0.1.2.tgz";
        sha1 = "00a0940f98cd501aeaaac316411d9adc52b31ab1";
      };
    }

    {
      name = "resize-img-1.1.2.tgz";
      path = fetchurl {
        name = "resize-img-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/resize-img/-/resize-img-1.1.2.tgz";
        sha1 = "fad650faf3ef2c53ea63112bc272d95e9d92550e";
      };
    }

    {
      name = "resolve-dir-1.0.1.tgz";
      path = fetchurl {
        name = "resolve-dir-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/resolve-dir/-/resolve-dir-1.0.1.tgz";
        sha1 = "79a40644c362be82f26effe739c9bb5382046f43";
      };
    }

    {
      name = "resolve-from-1.0.1.tgz";
      path = fetchurl {
        name = "resolve-from-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/resolve-from/-/resolve-from-1.0.1.tgz";
        sha1 = "26cbfe935d1aeeeabb29bc3fe5aeb01e93d44226";
      };
    }

    {
      name = "resolve-from-3.0.0.tgz";
      path = fetchurl {
        name = "resolve-from-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-from/-/resolve-from-3.0.0.tgz";
        sha1 = "b22c7af7d9d6881bc8b6e653335eebcb0a188748";
      };
    }

    {
      name = "resolve-from-4.0.0.tgz";
      path = fetchurl {
        name = "resolve-from-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz";
        sha1 = "4abcd852ad32dd7baabfe9b40e00a36db5f392e6";
      };
    }

    {
      name = "resolve-url-0.2.1.tgz";
      path = fetchurl {
        name = "resolve-url-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/resolve-url/-/resolve-url-0.2.1.tgz";
        sha1 = "2c637fe77c893afd2a663fe21aa9080068e2052a";
      };
    }

    {
      name = "resolve-1.5.0.tgz";
      path = fetchurl {
        name = "resolve-1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.5.0.tgz";
        sha1 = "1f09acce796c9a762579f31b2c1cc4c3cddf9f36";
      };
    }

    {
      name = "resolve-1.8.1.tgz";
      path = fetchurl {
        name = "resolve-1.8.1.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.8.1.tgz";
        sha1 = "82f1ec19a423ac1fbd080b0bab06ba36e84a7a26";
      };
    }

    {
      name = "restore-cursor-1.0.1.tgz";
      path = fetchurl {
        name = "restore-cursor-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-1.0.1.tgz";
        sha1 = "34661f46886327fed2991479152252df92daa541";
      };
    }

    {
      name = "restore-cursor-2.0.0.tgz";
      path = fetchurl {
        name = "restore-cursor-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-2.0.0.tgz";
        sha1 = "9f7ee287f82fd326d4fd162923d62129eee0dfaf";
      };
    }

    {
      name = "ret-0.1.15.tgz";
      path = fetchurl {
        name = "ret-0.1.15.tgz";
        url  = "https://registry.yarnpkg.com/ret/-/ret-0.1.15.tgz";
        sha1 = "b8a4825d5bdb1fc3f6f53c2bc33f81388681c7bc";
      };
    }

    {
      name = "retry-0.10.1.tgz";
      path = fetchurl {
        name = "retry-0.10.1.tgz";
        url  = "https://registry.yarnpkg.com/retry/-/retry-0.10.1.tgz";
        sha1 = "e76388d217992c252750241d3d3956fed98d8ff4";
      };
    }

    {
      name = "retry-0.12.0.tgz";
      path = fetchurl {
        name = "retry-0.12.0.tgz";
        url  = "https://registry.yarnpkg.com/retry/-/retry-0.12.0.tgz";
        sha1 = "1b42a6266a21f07421d1b0b54b7dc167b01c013b";
      };
    }

    {
      name = "rimraf-2.6.2.tgz";
      path = fetchurl {
        name = "rimraf-2.6.2.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-2.6.2.tgz";
        sha1 = "2ed8150d24a16ea8651e6d6ef0f47c4158ce7a36";
      };
    }

    {
      name = "rimraf-2.2.8.tgz";
      path = fetchurl {
        name = "rimraf-2.2.8.tgz";
        url  = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz";
        sha1 = "e439be2aaee327321952730f99a8929e4fc50582";
      };
    }

    {
      name = "ripemd160-2.0.2.tgz";
      path = fetchurl {
        name = "ripemd160-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/ripemd160/-/ripemd160-2.0.2.tgz";
        sha1 = "a1c1a6f624751577ba5d07914cbc92850585890c";
      };
    }

    {
      name = "rollup-pluginutils-2.3.1.tgz";
      path = fetchurl {
        name = "rollup-pluginutils-2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/rollup-pluginutils/-/rollup-pluginutils-2.3.1.tgz";
        sha1 = "760d185ccc237dedc12d7ae48c6bcd127b4892d0";
      };
    }

    {
      name = "rollup-0.57.1.tgz";
      path = fetchurl {
        name = "rollup-0.57.1.tgz";
        url  = "http://registry.npmjs.org/rollup/-/rollup-0.57.1.tgz";
        sha1 = "0bb28be6151d253f67cf4a00fea48fb823c74027";
      };
    }

    {
      name = "route-recognizer-0.2.10.tgz";
      path = fetchurl {
        name = "route-recognizer-0.2.10.tgz";
        url  = "https://registry.yarnpkg.com/route-recognizer/-/route-recognizer-0.2.10.tgz";
        sha1 = "024b2283c2e68d13a7c7f5173a5924645e8902df";
      };
    }

    {
      name = "route-recognizer-0.3.4.tgz";
      path = fetchurl {
        name = "route-recognizer-0.3.4.tgz";
        url  = "https://registry.yarnpkg.com/route-recognizer/-/route-recognizer-0.3.4.tgz";
        sha1 = "39ab1ffbce1c59e6d2bdca416f0932611e4f3ca3";
      };
    }

    {
      name = "rsvp-3.6.2.tgz";
      path = fetchurl {
        name = "rsvp-3.6.2.tgz";
        url  = "https://registry.yarnpkg.com/rsvp/-/rsvp-3.6.2.tgz";
        sha1 = "2e96491599a96cde1b515d5674a8f7a91452926a";
      };
    }

    {
      name = "rsvp-4.8.3.tgz";
      path = fetchurl {
        name = "rsvp-4.8.3.tgz";
        url  = "https://registry.yarnpkg.com/rsvp/-/rsvp-4.8.3.tgz";
        sha1 = "25d4b9fdd0f95e216eb5884d9b3767d3fbfbe2cd";
      };
    }

    {
      name = "rsvp-3.2.1.tgz";
      path = fetchurl {
        name = "rsvp-3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/rsvp/-/rsvp-3.2.1.tgz";
        sha1 = "07cb4a5df25add9e826ebc67dcc9fd89db27d84a";
      };
    }

    {
      name = "run-async-2.3.0.tgz";
      path = fetchurl {
        name = "run-async-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/run-async/-/run-async-2.3.0.tgz";
        sha1 = "0371ab4ae0bdd720d4166d7dfda64ff7a445a6c0";
      };
    }

    {
      name = "run-queue-1.0.3.tgz";
      path = fetchurl {
        name = "run-queue-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/run-queue/-/run-queue-1.0.3.tgz";
        sha1 = "e848396f057d223f24386924618e25694161ec47";
      };
    }

    {
      name = "rx-lite-aggregates-4.0.8.tgz";
      path = fetchurl {
        name = "rx-lite-aggregates-4.0.8.tgz";
        url  = "https://registry.yarnpkg.com/rx-lite-aggregates/-/rx-lite-aggregates-4.0.8.tgz";
        sha1 = "753b87a89a11c95467c4ac1626c4efc4e05c67be";
      };
    }

    {
      name = "rx-lite-4.0.8.tgz";
      path = fetchurl {
        name = "rx-lite-4.0.8.tgz";
        url  = "https://registry.yarnpkg.com/rx-lite/-/rx-lite-4.0.8.tgz";
        sha1 = "0b1e11af8bc44836f04a6407e92da42467b79444";
      };
    }

    {
      name = "rx-4.1.0.tgz";
      path = fetchurl {
        name = "rx-4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/rx/-/rx-4.1.0.tgz";
        sha1 = "a5f13ff79ef3b740fe30aa803fb09f98805d4782";
      };
    }

    {
      name = "rxjs-5.5.12.tgz";
      path = fetchurl {
        name = "rxjs-5.5.12.tgz";
        url  = "https://registry.yarnpkg.com/rxjs/-/rxjs-5.5.12.tgz";
        sha1 = "6fa61b8a77c3d793dbaf270bee2f43f652d741cc";
      };
    }

    {
      name = "safe-buffer-5.1.1.tgz";
      path = fetchurl {
        name = "safe-buffer-5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.1.tgz";
        sha1 = "893312af69b2123def71f57889001671eeb2c853";
      };
    }

    {
      name = "safe-buffer-5.1.2.tgz";
      path = fetchurl {
        name = "safe-buffer-5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz";
        sha1 = "991ec69d296e0313747d59bdfd2b745c35f8828d";
      };
    }

    {
      name = "safe-json-parse-1.0.1.tgz";
      path = fetchurl {
        name = "safe-json-parse-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/safe-json-parse/-/safe-json-parse-1.0.1.tgz";
        sha1 = "3e76723e38dfdda13c9b1d29a1e07ffee4b30b57";
      };
    }

    {
      name = "safe-regex-1.1.0.tgz";
      path = fetchurl {
        name = "safe-regex-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/safe-regex/-/safe-regex-1.1.0.tgz";
        sha1 = "40a3669f3b077d1e943d44629e157dd48023bf2e";
      };
    }

    {
      name = "safer-buffer-2.1.2.tgz";
      path = fetchurl {
        name = "safer-buffer-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz";
        sha1 = "44fa161b0187b9549dd84bb91802f9bd8385cd6a";
      };
    }

    {
      name = "samsam-1.3.0.tgz";
      path = fetchurl {
        name = "samsam-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/samsam/-/samsam-1.3.0.tgz";
        sha1 = "8d1d9350e25622da30de3e44ba692b5221ab7c50";
      };
    }

    {
      name = "sane-2.5.2.tgz";
      path = fetchurl {
        name = "sane-2.5.2.tgz";
        url  = "https://registry.yarnpkg.com/sane/-/sane-2.5.2.tgz";
        sha1 = "b4dc1861c21b427e929507a3e751e2a2cb8ab3fa";
      };
    }

    {
      name = "sane-3.0.0.tgz";
      path = fetchurl {
        name = "sane-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/sane/-/sane-3.0.0.tgz";
        sha1 = "32e88d110b32dcd0ae3b88bdc58d8e4762cdf49a";
      };
    }

    {
      name = "sass-graph-2.2.4.tgz";
      path = fetchurl {
        name = "sass-graph-2.2.4.tgz";
        url  = "https://registry.yarnpkg.com/sass-graph/-/sass-graph-2.2.4.tgz";
        sha1 = "13fbd63cd1caf0908b9fd93476ad43a51d1e0b49";
      };
    }

    {
      name = "sass-svg-uri-1.0.0.tgz";
      path = fetchurl {
        name = "sass-svg-uri-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/sass-svg-uri/-/sass-svg-uri-1.0.0.tgz";
        sha1 = "01e992e4e3ce8d1ec4eac4c8280c0f2ef45c6be8";
      };
    }

    {
      name = "sax-1.2.4.tgz";
      path = fetchurl {
        name = "sax-1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz";
        sha1 = "2816234e2378bddc4e5354fab5caa895df7100d9";
      };
    }

    {
      name = "schema-utils-0.4.7.tgz";
      path = fetchurl {
        name = "schema-utils-0.4.7.tgz";
        url  = "https://registry.yarnpkg.com/schema-utils/-/schema-utils-0.4.7.tgz";
        sha1 = "ba74f597d2be2ea880131746ee17d0a093c68187";
      };
    }

    {
      name = "scss-tokenizer-0.2.3.tgz";
      path = fetchurl {
        name = "scss-tokenizer-0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/scss-tokenizer/-/scss-tokenizer-0.2.3.tgz";
        sha1 = "8eb06db9a9723333824d3f5530641149847ce5d1";
      };
    }

    {
      name = "select-1.1.2.tgz";
      path = fetchurl {
        name = "select-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/select/-/select-1.1.2.tgz";
        sha1 = "0e7350acdec80b1108528786ec1d4418d11b396d";
      };
    }

    {
      name = "semantic-release-15.9.14.tgz";
      path = fetchurl {
        name = "semantic-release-15.9.14.tgz";
        url  = "https://registry.yarnpkg.com/semantic-release/-/semantic-release-15.9.14.tgz";
        sha1 = "108fa88649e318b85f728adc9375b12d68075726";
      };
    }

    {
      name = "semver-diff-2.1.0.tgz";
      path = fetchurl {
        name = "semver-diff-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/semver-diff/-/semver-diff-2.1.0.tgz";
        sha1 = "4bbb8437c8d37e4b0cf1a68fd726ec6d645d6d36";
      };
    }

    {
      name = "semver-regex-1.0.0.tgz";
      path = fetchurl {
        name = "semver-regex-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/semver-regex/-/semver-regex-1.0.0.tgz";
        sha1 = "92a4969065f9c70c694753d55248fc68f8f652c9";
      };
    }

    {
      name = "semver-5.5.1.tgz";
      path = fetchurl {
        name = "semver-5.5.1.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.5.1.tgz";
        sha1 = "7dfdd8814bdb7cabc7be0fb1d734cfb66c940477";
      };
    }

    {
      name = "semver-5.5.0.tgz";
      path = fetchurl {
        name = "semver-5.5.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.5.0.tgz";
        sha1 = "dc4bbc7a6ca9d916dee5d43516f0092b58f7b8ab";
      };
    }

    {
      name = "semver-5.3.0.tgz";
      path = fetchurl {
        name = "semver-5.3.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.3.0.tgz";
        sha1 = "9b2ce5d3de02d17c6012ad326aa6b4d0cf54f94f";
      };
    }

    {
      name = "send-0.16.2.tgz";
      path = fetchurl {
        name = "send-0.16.2.tgz";
        url  = "https://registry.yarnpkg.com/send/-/send-0.16.2.tgz";
        sha1 = "6ecca1e0f8c156d141597559848df64730a6bbc1";
      };
    }

    {
      name = "serialize-javascript-1.5.0.tgz";
      path = fetchurl {
        name = "serialize-javascript-1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-1.5.0.tgz";
        sha1 = "1aa336162c88a890ddad5384baebc93a655161fe";
      };
    }

    {
      name = "serve-static-1.13.2.tgz";
      path = fetchurl {
        name = "serve-static-1.13.2.tgz";
        url  = "https://registry.yarnpkg.com/serve-static/-/serve-static-1.13.2.tgz";
        sha1 = "095e8472fd5b46237db50ce486a43f4b86c6cec1";
      };
    }

    {
      name = "set-blocking-2.0.0.tgz";
      path = fetchurl {
        name = "set-blocking-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz";
        sha1 = "045f9782d011ae9a6803ddd382b24392b3d890f7";
      };
    }

    {
      name = "set-immediate-shim-1.0.1.tgz";
      path = fetchurl {
        name = "set-immediate-shim-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/set-immediate-shim/-/set-immediate-shim-1.0.1.tgz";
        sha1 = "4b2b1b27eb808a9f8dcc481a58e5e56f599f3f61";
      };
    }

    {
      name = "set-value-0.4.3.tgz";
      path = fetchurl {
        name = "set-value-0.4.3.tgz";
        url  = "https://registry.yarnpkg.com/set-value/-/set-value-0.4.3.tgz";
        sha1 = "7db08f9d3d22dc7f78e53af3c3bf4666ecdfccf1";
      };
    }

    {
      name = "set-value-2.0.0.tgz";
      path = fetchurl {
        name = "set-value-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/set-value/-/set-value-2.0.0.tgz";
        sha1 = "71ae4a88f0feefbbf52d1ea604f3fb315ebb6274";
      };
    }

    {
      name = "setimmediate-1.0.5.tgz";
      path = fetchurl {
        name = "setimmediate-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/setimmediate/-/setimmediate-1.0.5.tgz";
        sha1 = "290cbb232e306942d7d7ea9b83732ab7856f8285";
      };
    }

    {
      name = "setprototypeof-1.0.3.tgz";
      path = fetchurl {
        name = "setprototypeof-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.0.3.tgz";
        sha1 = "66567e37043eeb4f04d91bd658c0cbefb55b8e04";
      };
    }

    {
      name = "setprototypeof-1.1.0.tgz";
      path = fetchurl {
        name = "setprototypeof-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.1.0.tgz";
        sha1 = "d0bd85536887b6fe7c0d818cb962d9d91c54e656";
      };
    }

    {
      name = "sha.js-2.4.11.tgz";
      path = fetchurl {
        name = "sha.js-2.4.11.tgz";
        url  = "https://registry.yarnpkg.com/sha.js/-/sha.js-2.4.11.tgz";
        sha1 = "37a5cf0b81ecbc6943de109ba2960d1b26584ae7";
      };
    }

    {
      name = "sha-2.0.1.tgz";
      path = fetchurl {
        name = "sha-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/sha/-/sha-2.0.1.tgz";
        sha1 = "6030822fbd2c9823949f8f72ed6411ee5cf25aae";
      };
    }

    {
      name = "shebang-command-1.2.0.tgz";
      path = fetchurl {
        name = "shebang-command-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz";
        sha1 = "44aac65b695b03398968c39f363fee5deafdf1ea";
      };
    }

    {
      name = "shebang-regex-1.0.0.tgz";
      path = fetchurl {
        name = "shebang-regex-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz";
        sha1 = "da42f49740c0b42db2ca9728571cb190c98efea3";
      };
    }

    {
      name = "shellwords-0.1.1.tgz";
      path = fetchurl {
        name = "shellwords-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/shellwords/-/shellwords-0.1.1.tgz";
        sha1 = "d6b9181c1a48d397324c84871efbcfc73fc0654b";
      };
    }

    {
      name = "sigmund-1.0.1.tgz";
      path = fetchurl {
        name = "sigmund-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/sigmund/-/sigmund-1.0.1.tgz";
        sha1 = "3ff21f198cad2175f9f3b781853fd94d0d19b590";
      };
    }

    {
      name = "signal-exit-3.0.2.tgz";
      path = fetchurl {
        name = "signal-exit-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.2.tgz";
        sha1 = "b5fdc08f1287ea1178628e415e25132b73646c6d";
      };
    }

    {
      name = "signale-1.3.0.tgz";
      path = fetchurl {
        name = "signale-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/signale/-/signale-1.3.0.tgz";
        sha1 = "1b4917c2c7a8691550adca0ad1da750a662b4497";
      };
    }

    {
      name = "silent-error-1.1.0.tgz";
      path = fetchurl {
        name = "silent-error-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/silent-error/-/silent-error-1.1.0.tgz";
        sha1 = "2209706f1c850a9f1d10d0d840918b46f26e1bc9";
      };
    }

    {
      name = "simple-html-tokenizer-0.5.6.tgz";
      path = fetchurl {
        name = "simple-html-tokenizer-0.5.6.tgz";
        url  = "https://registry.yarnpkg.com/simple-html-tokenizer/-/simple-html-tokenizer-0.5.6.tgz";
        sha1 = "e1e442b14f5484bf9a7e2924f78f00855e6b3c14";
      };
    }

    {
      name = "simple-swizzle-0.2.2.tgz";
      path = fetchurl {
        name = "simple-swizzle-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/simple-swizzle/-/simple-swizzle-0.2.2.tgz";
        sha1 = "a4da6b635ffcccca33f70d17cb92592de95e557a";
      };
    }

    {
      name = "sinon-3.3.0.tgz";
      path = fetchurl {
        name = "sinon-3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/sinon/-/sinon-3.3.0.tgz";
        sha1 = "9132111b4bbe13c749c2848210864250165069b1";
      };
    }

    {
      name = "slash-1.0.0.tgz";
      path = fetchurl {
        name = "slash-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/slash/-/slash-1.0.0.tgz";
        sha1 = "c41f2f6c39fc16d1cd17ad4b5d896114ae470d55";
      };
    }

    {
      name = "slice-ansi-1.0.0.tgz";
      path = fetchurl {
        name = "slice-ansi-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-1.0.0.tgz";
        sha1 = "044f1a49d8842ff307aad6b505ed178bd950134d";
      };
    }

    {
      name = "slide-1.1.6.tgz";
      path = fetchurl {
        name = "slide-1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/slide/-/slide-1.1.6.tgz";
        sha1 = "56eb027d65b4d2dce6cb2e2d32c4d4afc9e1d707";
      };
    }

    {
      name = "smart-buffer-1.1.15.tgz";
      path = fetchurl {
        name = "smart-buffer-1.1.15.tgz";
        url  = "https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-1.1.15.tgz";
        sha1 = "7f114b5b65fab3e2a35aa775bb12f0d1c649bf16";
      };
    }

    {
      name = "smart-buffer-4.0.1.tgz";
      path = fetchurl {
        name = "smart-buffer-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-4.0.1.tgz";
        sha1 = "07ea1ca8d4db24eb4cac86537d7d18995221ace3";
      };
    }

    {
      name = "snake-case-2.1.0.tgz";
      path = fetchurl {
        name = "snake-case-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/snake-case/-/snake-case-2.1.0.tgz";
        sha1 = "41bdb1b73f30ec66a04d4e2cad1b76387d4d6d9f";
      };
    }

    {
      name = "snapdragon-node-2.1.1.tgz";
      path = fetchurl {
        name = "snapdragon-node-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/snapdragon-node/-/snapdragon-node-2.1.1.tgz";
        sha1 = "6c175f86ff14bdb0724563e8f3c1b021a286853b";
      };
    }

    {
      name = "snapdragon-util-3.0.1.tgz";
      path = fetchurl {
        name = "snapdragon-util-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/snapdragon-util/-/snapdragon-util-3.0.1.tgz";
        sha1 = "f956479486f2acd79700693f6f7b805e45ab56e2";
      };
    }

    {
      name = "snapdragon-0.8.2.tgz";
      path = fetchurl {
        name = "snapdragon-0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/snapdragon/-/snapdragon-0.8.2.tgz";
        sha1 = "64922e7c565b0e14204ba1aa7d6964278d25182d";
      };
    }

    {
      name = "socket.io-adapter-1.1.1.tgz";
      path = fetchurl {
        name = "socket.io-adapter-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-adapter/-/socket.io-adapter-1.1.1.tgz";
        sha1 = "2a805e8a14d6372124dd9159ad4502f8cb07f06b";
      };
    }

    {
      name = "socket.io-client-2.1.1.tgz";
      path = fetchurl {
        name = "socket.io-client-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-client/-/socket.io-client-2.1.1.tgz";
        sha1 = "dcb38103436ab4578ddb026638ae2f21b623671f";
      };
    }

    {
      name = "socket.io-parser-3.2.0.tgz";
      path = fetchurl {
        name = "socket.io-parser-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-parser/-/socket.io-parser-3.2.0.tgz";
        sha1 = "e7c6228b6aa1f814e6148aea325b51aa9499e077";
      };
    }

    {
      name = "socket.io-2.1.1.tgz";
      path = fetchurl {
        name = "socket.io-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/socket.io/-/socket.io-2.1.1.tgz";
        sha1 = "a069c5feabee3e6b214a75b40ce0652e1cfb9980";
      };
    }

    {
      name = "socks-proxy-agent-3.0.1.tgz";
      path = fetchurl {
        name = "socks-proxy-agent-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/socks-proxy-agent/-/socks-proxy-agent-3.0.1.tgz";
        sha1 = "2eae7cf8e2a82d34565761539a7f9718c5617659";
      };
    }

    {
      name = "socks-proxy-agent-4.0.1.tgz";
      path = fetchurl {
        name = "socks-proxy-agent-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/socks-proxy-agent/-/socks-proxy-agent-4.0.1.tgz";
        sha1 = "5936bf8b707a993079c6f37db2091821bffa6473";
      };
    }

    {
      name = "socks-1.1.10.tgz";
      path = fetchurl {
        name = "socks-1.1.10.tgz";
        url  = "https://registry.yarnpkg.com/socks/-/socks-1.1.10.tgz";
        sha1 = "5b8b7fc7c8f341c53ed056e929b7bf4de8ba7b5a";
      };
    }

    {
      name = "socks-2.2.1.tgz";
      path = fetchurl {
        name = "socks-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/socks/-/socks-2.2.1.tgz";
        sha1 = "68ad678b3642fbc5d99c64c165bc561eab0215f9";
      };
    }

    {
      name = "sort-object-keys-1.1.2.tgz";
      path = fetchurl {
        name = "sort-object-keys-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/sort-object-keys/-/sort-object-keys-1.1.2.tgz";
        sha1 = "d3a6c48dc2ac97e6bc94367696e03f6d09d37952";
      };
    }

    {
      name = "sort-package-json-1.15.0.tgz";
      path = fetchurl {
        name = "sort-package-json-1.15.0.tgz";
        url  = "https://registry.yarnpkg.com/sort-package-json/-/sort-package-json-1.15.0.tgz";
        sha1 = "3c732cc8312eb4aa12f6eccab1bc3dea89b11dff";
      };
    }

    {
      name = "sorted-object-2.0.1.tgz";
      path = fetchurl {
        name = "sorted-object-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/sorted-object/-/sorted-object-2.0.1.tgz";
        sha1 = "7d631f4bd3a798a24af1dffcfbfe83337a5df5fc";
      };
    }

    {
      name = "sorted-union-stream-2.1.3.tgz";
      path = fetchurl {
        name = "sorted-union-stream-2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/sorted-union-stream/-/sorted-union-stream-2.1.3.tgz";
        sha1 = "c7794c7e077880052ff71a8d4a2dbb4a9a638ac7";
      };
    }

    {
      name = "source-list-map-2.0.0.tgz";
      path = fetchurl {
        name = "source-list-map-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/source-list-map/-/source-list-map-2.0.0.tgz";
        sha1 = "aaa47403f7b245a92fbc97ea08f250d6087ed085";
      };
    }

    {
      name = "source-map-resolve-0.5.2.tgz";
      path = fetchurl {
        name = "source-map-resolve-0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/source-map-resolve/-/source-map-resolve-0.5.2.tgz";
        sha1 = "72e2cc34095543e43b2c62b2c4c10d4a9054f259";
      };
    }

    {
      name = "source-map-support-0.4.18.tgz";
      path = fetchurl {
        name = "source-map-support-0.4.18.tgz";
        url  = "https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.4.18.tgz";
        sha1 = "0286a6de8be42641338594e97ccea75f0a2c585f";
      };
    }

    {
      name = "source-map-support-0.5.9.tgz";
      path = fetchurl {
        name = "source-map-support-0.5.9.tgz";
        url  = "https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.9.tgz";
        sha1 = "41bc953b2534267ea2d605bccfa7bfa3111ced5f";
      };
    }

    {
      name = "source-map-url-0.3.0.tgz";
      path = fetchurl {
        name = "source-map-url-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/source-map-url/-/source-map-url-0.3.0.tgz";
        sha1 = "7ecaf13b57bcd09da8a40c5d269db33799d4aaf9";
      };
    }

    {
      name = "source-map-url-0.4.0.tgz";
      path = fetchurl {
        name = "source-map-url-0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/source-map-url/-/source-map-url-0.4.0.tgz";
        sha1 = "3e935d7ddd73631b97659956d55128e87b5084a3";
      };
    }

    {
      name = "source-map-0.4.4.tgz";
      path = fetchurl {
        name = "source-map-0.4.4.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.4.4.tgz";
        sha1 = "eba4f5da9c0dc999de68032d8b4f76173652036b";
      };
    }

    {
      name = "source-map-0.5.7.tgz";
      path = fetchurl {
        name = "source-map-0.5.7.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz";
        sha1 = "8a039d2d1021d22d1ea14c80d8ea468ba2ef3fcc";
      };
    }

    {
      name = "source-map-0.6.1.tgz";
      path = fetchurl {
        name = "source-map-0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz";
        sha1 = "74722af32e9614e9c287a8d0bbde48b5e2f1a263";
      };
    }

    {
      name = "source-map-0.1.43.tgz";
      path = fetchurl {
        name = "source-map-0.1.43.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.1.43.tgz";
        sha1 = "c24bc146ca517c1471f5dacbe2571b2b7f9e3346";
      };
    }

    {
      name = "sourcemap-codec-1.4.1.tgz";
      path = fetchurl {
        name = "sourcemap-codec-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/sourcemap-codec/-/sourcemap-codec-1.4.1.tgz";
        sha1 = "c8fd92d91889e902a07aee392bdd2c5863958ba2";
      };
    }

    {
      name = "sourcemap-validator-1.1.0.tgz";
      path = fetchurl {
        name = "sourcemap-validator-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/sourcemap-validator/-/sourcemap-validator-1.1.0.tgz";
        sha1 = "00454547d1682186e1498a7208e022e8dfa8738f";
      };
    }

    {
      name = "spawn-args-0.2.0.tgz";
      path = fetchurl {
        name = "spawn-args-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/spawn-args/-/spawn-args-0.2.0.tgz";
        sha1 = "fb7d0bd1d70fd4316bd9e3dec389e65f9d6361bb";
      };
    }

    {
      name = "spawn-error-forwarder-1.0.0.tgz";
      path = fetchurl {
        name = "spawn-error-forwarder-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/spawn-error-forwarder/-/spawn-error-forwarder-1.0.0.tgz";
        sha1 = "1afd94738e999b0346d7b9fc373be55e07577029";
      };
    }

    {
      name = "spawn-sync-1.0.15.tgz";
      path = fetchurl {
        name = "spawn-sync-1.0.15.tgz";
        url  = "https://registry.yarnpkg.com/spawn-sync/-/spawn-sync-1.0.15.tgz";
        sha1 = "b00799557eb7fb0c8376c29d44e8a1ea67e57476";
      };
    }

    {
      name = "spdx-correct-3.0.0.tgz";
      path = fetchurl {
        name = "spdx-correct-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.0.0.tgz";
        sha1 = "05a5b4d7153a195bc92c3c425b69f3b2a9524c82";
      };
    }

    {
      name = "spdx-exceptions-2.1.0.tgz";
      path = fetchurl {
        name = "spdx-exceptions-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.1.0.tgz";
        sha1 = "2c7ae61056c714a5b9b9b2b2af7d311ef5c78fe9";
      };
    }

    {
      name = "spdx-expression-parse-3.0.0.tgz";
      path = fetchurl {
        name = "spdx-expression-parse-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.0.tgz";
        sha1 = "99e119b7a5da00e05491c9fa338b7904823b41d0";
      };
    }

    {
      name = "spdx-license-ids-3.0.1.tgz";
      path = fetchurl {
        name = "spdx-license-ids-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.1.tgz";
        sha1 = "e2a303236cac54b04031fa7a5a79c7e701df852f";
      };
    }

    {
      name = "split-string-3.1.0.tgz";
      path = fetchurl {
        name = "split-string-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/split-string/-/split-string-3.1.0.tgz";
        sha1 = "7cb09dda3a86585705c64b39a6466038682e8fe2";
      };
    }

    {
      name = "split2-2.2.0.tgz";
      path = fetchurl {
        name = "split2-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/split2/-/split2-2.2.0.tgz";
        sha1 = "186b2575bcf83e85b7d18465756238ee4ee42493";
      };
    }

    {
      name = "split2-1.0.0.tgz";
      path = fetchurl {
        name = "split2-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/split2/-/split2-1.0.0.tgz";
        sha1 = "52e2e221d88c75f9a73f90556e263ff96772b314";
      };
    }

    {
      name = "split-1.0.1.tgz";
      path = fetchurl {
        name = "split-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/split/-/split-1.0.1.tgz";
        sha1 = "605bd9be303aa59fb35f9229fbea0ddec9ea07d9";
      };
    }

    {
      name = "sprintf-js-1.1.1.tgz";
      path = fetchurl {
        name = "sprintf-js-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.1.tgz";
        sha1 = "36be78320afe5801f6cea3ee78b6e5aab940ea0c";
      };
    }

    {
      name = "sprintf-js-1.0.3.tgz";
      path = fetchurl {
        name = "sprintf-js-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz";
        sha1 = "04e6926f662895354f3dd015203633b857297e2c";
      };
    }

    {
      name = "sri-toolbox-0.2.0.tgz";
      path = fetchurl {
        name = "sri-toolbox-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/sri-toolbox/-/sri-toolbox-0.2.0.tgz";
        sha1 = "a7fea5c3fde55e675cf1c8c06f3ebb5c2935835e";
      };
    }

    {
      name = "sshpk-1.14.2.tgz";
      path = fetchurl {
        name = "sshpk-1.14.2.tgz";
        url  = "https://registry.yarnpkg.com/sshpk/-/sshpk-1.14.2.tgz";
        sha1 = "c6fc61648a3d9c4e764fd3fcdf4ea105e492ba98";
      };
    }

    {
      name = "ssri-5.3.0.tgz";
      path = fetchurl {
        name = "ssri-5.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ssri/-/ssri-5.3.0.tgz";
        sha1 = "ba3872c9c6d33a0704a7d71ff045e5ec48999d06";
      };
    }

    {
      name = "ssri-6.0.1.tgz";
      path = fetchurl {
        name = "ssri-6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ssri/-/ssri-6.0.1.tgz";
        sha1 = "2a3c41b28dd45b62b63676ecb74001265ae9edd8";
      };
    }

    {
      name = "stack-trace-0.0.10.tgz";
      path = fetchurl {
        name = "stack-trace-0.0.10.tgz";
        url  = "https://registry.yarnpkg.com/stack-trace/-/stack-trace-0.0.10.tgz";
        sha1 = "547c70b347e8d32b4e108ea1a2a159e5fdde19c0";
      };
    }

    {
      name = "static-extend-0.1.2.tgz";
      path = fetchurl {
        name = "static-extend-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/static-extend/-/static-extend-0.1.2.tgz";
        sha1 = "60809c39cbff55337226fd5e0b520f341f1fb5c6";
      };
    }

    {
      name = "statuses-1.5.0.tgz";
      path = fetchurl {
        name = "statuses-1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/statuses/-/statuses-1.5.0.tgz";
        sha1 = "161c7dac177659fd9811f43771fa99381478628c";
      };
    }

    {
      name = "statuses-1.4.0.tgz";
      path = fetchurl {
        name = "statuses-1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/statuses/-/statuses-1.4.0.tgz";
        sha1 = "bb73d446da2796106efcc1b601a253d6c46bd087";
      };
    }

    {
      name = "stdout-stream-1.4.1.tgz";
      path = fetchurl {
        name = "stdout-stream-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/stdout-stream/-/stdout-stream-1.4.1.tgz";
        sha1 = "5ac174cdd5cd726104aa0c0b2bd83815d8d535de";
      };
    }

    {
      name = "stealthy-require-1.1.1.tgz";
      path = fetchurl {
        name = "stealthy-require-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/stealthy-require/-/stealthy-require-1.1.1.tgz";
        sha1 = "35b09875b4ff49f26a777e509b3090a3226bf24b";
      };
    }

    {
      name = "stream-browserify-2.0.1.tgz";
      path = fetchurl {
        name = "stream-browserify-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/stream-browserify/-/stream-browserify-2.0.1.tgz";
        sha1 = "66266ee5f9bdb9940a4e4514cafb43bb71e5c9db";
      };
    }

    {
      name = "stream-combiner2-1.1.1.tgz";
      path = fetchurl {
        name = "stream-combiner2-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/stream-combiner2/-/stream-combiner2-1.1.1.tgz";
        sha1 = "fb4d8a1420ea362764e21ad4780397bebcb41cbe";
      };
    }

    {
      name = "stream-each-1.2.3.tgz";
      path = fetchurl {
        name = "stream-each-1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/stream-each/-/stream-each-1.2.3.tgz";
        sha1 = "ebe27a0c389b04fbcc233642952e10731afa9bae";
      };
    }

    {
      name = "stream-http-2.8.3.tgz";
      path = fetchurl {
        name = "stream-http-2.8.3.tgz";
        url  = "https://registry.yarnpkg.com/stream-http/-/stream-http-2.8.3.tgz";
        sha1 = "b2d242469288a5a27ec4fe8933acf623de6514fc";
      };
    }

    {
      name = "stream-iterate-1.2.0.tgz";
      path = fetchurl {
        name = "stream-iterate-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/stream-iterate/-/stream-iterate-1.2.0.tgz";
        sha1 = "2bd7c77296c1702a46488b8ad41f79865eecd4e1";
      };
    }

    {
      name = "stream-shift-1.0.0.tgz";
      path = fetchurl {
        name = "stream-shift-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stream-shift/-/stream-shift-1.0.0.tgz";
        sha1 = "d5c752825e5367e786f78e18e445ea223a155952";
      };
    }

    {
      name = "stream-to-buffer-0.1.0.tgz";
      path = fetchurl {
        name = "stream-to-buffer-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/stream-to-buffer/-/stream-to-buffer-0.1.0.tgz";
        sha1 = "26799d903ab2025c9bd550ac47171b00f8dd80a9";
      };
    }

    {
      name = "stream-to-0.2.2.tgz";
      path = fetchurl {
        name = "stream-to-0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/stream-to/-/stream-to-0.2.2.tgz";
        sha1 = "84306098d85fdb990b9fa300b1b3ccf55e8ef01d";
      };
    }

    {
      name = "strict-uri-encode-2.0.0.tgz";
      path = fetchurl {
        name = "strict-uri-encode-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strict-uri-encode/-/strict-uri-encode-2.0.0.tgz";
        sha1 = "b9c7330c7042862f6b142dc274bbcc5866ce3546";
      };
    }

    {
      name = "string-template-0.2.1.tgz";
      path = fetchurl {
        name = "string-template-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/string-template/-/string-template-0.2.1.tgz";
        sha1 = "42932e598a352d01fc22ec3367d9d84eec6c9add";
      };
    }

    {
      name = "string-width-1.0.2.tgz";
      path = fetchurl {
        name = "string-width-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz";
        sha1 = "118bdf5b8cdc51a2a7e70d211e07e2b0b9b107d3";
      };
    }

    {
      name = "string-width-2.1.1.tgz";
      path = fetchurl {
        name = "string-width-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz";
        sha1 = "ab93f27a8dc13d28cac815c462143a6d9012ae9e";
      };
    }

    {
      name = "string.prototype.endswith-0.2.0.tgz";
      path = fetchurl {
        name = "string.prototype.endswith-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.endswith/-/string.prototype.endswith-0.2.0.tgz";
        sha1 = "a19c20dee51a98777e9a47e10f09be393b9bba75";
      };
    }

    {
      name = "string.prototype.startswith-0.2.0.tgz";
      path = fetchurl {
        name = "string.prototype.startswith-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.startswith/-/string.prototype.startswith-0.2.0.tgz";
        sha1 = "da68982e353a4e9ac4a43b450a2045d1c445ae7b";
      };
    }

    {
      name = "string_decoder-0.10.31.tgz";
      path = fetchurl {
        name = "string_decoder-0.10.31.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
      };
    }

    {
      name = "string_decoder-1.1.1.tgz";
      path = fetchurl {
        name = "string_decoder-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz";
        sha1 = "9cf1611ba62685d7030ae9e4ba34149c3af03fc8";
      };
    }

    {
      name = "stringify-package-1.0.0.tgz";
      path = fetchurl {
        name = "stringify-package-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stringify-package/-/stringify-package-1.0.0.tgz";
        sha1 = "e02828089333d7d45cd8c287c30aa9a13375081b";
      };
    }

    {
      name = "strip-ansi-3.0.1.tgz";
      path = fetchurl {
        name = "strip-ansi-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz";
        sha1 = "6a385fb8853d952d5ff05d0e8aaf94278dc63dcf";
      };
    }

    {
      name = "strip-ansi-4.0.0.tgz";
      path = fetchurl {
        name = "strip-ansi-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-4.0.0.tgz";
        sha1 = "a8479022eb1ac368a871389b635262c505ee368f";
      };
    }

    {
      name = "strip-ansi-0.1.1.tgz";
      path = fetchurl {
        name = "strip-ansi-0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-0.1.1.tgz";
        sha1 = "39e8a98d044d150660abe4a6808acf70bb7bc991";
      };
    }

    {
      name = "strip-bom-2.0.0.tgz";
      path = fetchurl {
        name = "strip-bom-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-bom/-/strip-bom-2.0.0.tgz";
        sha1 = "6219a85616520491f35788bdbf1447a99c7e6b0e";
      };
    }

    {
      name = "strip-bom-3.0.0.tgz";
      path = fetchurl {
        name = "strip-bom-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz";
        sha1 = "2334c18e9c759f7bdd56fdef7e9ae3d588e68ed3";
      };
    }

    {
      name = "strip-eof-1.0.0.tgz";
      path = fetchurl {
        name = "strip-eof-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-eof/-/strip-eof-1.0.0.tgz";
        sha1 = "bb43ff5598a6eb05d89b59fcd129c983313606bf";
      };
    }

    {
      name = "strip-indent-1.0.1.tgz";
      path = fetchurl {
        name = "strip-indent-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-indent/-/strip-indent-1.0.1.tgz";
        sha1 = "0c7962a6adefa7bbd4ac366460a638552ae1a0a2";
      };
    }

    {
      name = "strip-indent-2.0.0.tgz";
      path = fetchurl {
        name = "strip-indent-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-indent/-/strip-indent-2.0.0.tgz";
        sha1 = "5ef8db295d01e6ed6cbf7aab96998d7822527b68";
      };
    }

    {
      name = "strip-json-comments-2.0.1.tgz";
      path = fetchurl {
        name = "strip-json-comments-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz";
        sha1 = "3c531942e908c2697c0ec344858c286c7ca0a60a";
      };
    }

    {
      name = "styled_string-0.0.1.tgz";
      path = fetchurl {
        name = "styled_string-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/styled_string/-/styled_string-0.0.1.tgz";
        sha1 = "d22782bd81295459bc4f1df18c4bad8e94dd124a";
      };
    }

    {
      name = "sum-up-1.0.3.tgz";
      path = fetchurl {
        name = "sum-up-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/sum-up/-/sum-up-1.0.3.tgz";
        sha1 = "1c661f667057f63bcb7875aa1438bc162525156e";
      };
    }

    {
      name = "supports-color-2.0.0.tgz";
      path = fetchurl {
        name = "supports-color-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-2.0.0.tgz";
        sha1 = "535d045ce6b6363fa40117084629995e9df324c7";
      };
    }

    {
      name = "supports-color-4.5.0.tgz";
      path = fetchurl {
        name = "supports-color-4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-4.5.0.tgz";
        sha1 = "be7a0de484dec5c5cddf8b3d59125044912f635b";
      };
    }

    {
      name = "supports-color-5.5.0.tgz";
      path = fetchurl {
        name = "supports-color-5.5.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz";
        sha1 = "e2e69a44ac8772f78a1ec0b35b689df6530efc8f";
      };
    }

    {
      name = "svg2png-3.0.1.tgz";
      path = fetchurl {
        name = "svg2png-3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/svg2png/-/svg2png-3.0.1.tgz";
        sha1 = "a2644d68b0231ac00af431aa163714ff17106447";
      };
    }

    {
      name = "symbol-observable-1.0.1.tgz";
      path = fetchurl {
        name = "symbol-observable-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-1.0.1.tgz";
        sha1 = "8340fc4702c3122df5d22288f88283f513d3fdd4";
      };
    }

    {
      name = "symbol-tree-3.2.2.tgz";
      path = fetchurl {
        name = "symbol-tree-3.2.2.tgz";
        url  = "https://registry.yarnpkg.com/symbol-tree/-/symbol-tree-3.2.2.tgz";
        sha1 = "ae27db38f660a7ae2e1c3b7d1bc290819b8519e6";
      };
    }

    {
      name = "symlink-or-copy-1.2.0.tgz";
      path = fetchurl {
        name = "symlink-or-copy-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/symlink-or-copy/-/symlink-or-copy-1.2.0.tgz";
        sha1 = "5d49108e2ab824a34069b68974486c290020b393";
      };
    }

    {
      name = "table-4.0.2.tgz";
      path = fetchurl {
        name = "table-4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/table/-/table-4.0.2.tgz";
        sha1 = "a33447375391e766ad34d3486e6e2aedc84d2e36";
      };
    }

    {
      name = "tap-parser-7.0.0.tgz";
      path = fetchurl {
        name = "tap-parser-7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/tap-parser/-/tap-parser-7.0.0.tgz";
        sha1 = "54db35302fda2c2ccc21954ad3be22b2cba42721";
      };
    }

    {
      name = "tapable-1.0.0.tgz";
      path = fetchurl {
        name = "tapable-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/tapable/-/tapable-1.0.0.tgz";
        sha1 = "cbb639d9002eed9c6b5975eb20598d7936f1f9f2";
      };
    }

    {
      name = "tar-2.2.1.tgz";
      path = fetchurl {
        name = "tar-2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/tar/-/tar-2.2.1.tgz";
        sha1 = "8e4d2a256c0e2185c6b18ad694aec968b83cb1d1";
      };
    }

    {
      name = "tar-4.4.6.tgz";
      path = fetchurl {
        name = "tar-4.4.6.tgz";
        url  = "https://registry.yarnpkg.com/tar/-/tar-4.4.6.tgz";
        sha1 = "63110f09c00b4e60ac8bcfe1bf3c8660235fbc9b";
      };
    }

    {
      name = "temp-0.8.3.tgz";
      path = fetchurl {
        name = "temp-0.8.3.tgz";
        url  = "https://registry.yarnpkg.com/temp/-/temp-0.8.3.tgz";
        sha1 = "e0c6bc4d26b903124410e4fed81103014dfc1f59";
      };
    }

    {
      name = "term-size-1.2.0.tgz";
      path = fetchurl {
        name = "term-size-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/term-size/-/term-size-1.2.0.tgz";
        sha1 = "458b83887f288fc56d6fffbfad262e26638efa69";
      };
    }

    {
      name = "terser-3.8.2.tgz";
      path = fetchurl {
        name = "terser-3.8.2.tgz";
        url  = "https://registry.yarnpkg.com/terser/-/terser-3.8.2.tgz";
        sha1 = "48b880f949f8d038aca4dfd00a37c53d96ecf9fb";
      };
    }

    {
      name = "testem-2.11.0.tgz";
      path = fetchurl {
        name = "testem-2.11.0.tgz";
        url  = "https://registry.yarnpkg.com/testem/-/testem-2.11.0.tgz";
        sha1 = "3e561fc0892ed3df8da94a55bcc2c51688b4c533";
      };
    }

    {
      name = "text-encoder-lite-1.0.0.tgz";
      path = fetchurl {
        name = "text-encoder-lite-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/text-encoder-lite/-/text-encoder-lite-1.0.0.tgz";
        sha1 = "158ac1f5355bd291b143bdc88f1996ce34df3c12";
      };
    }

    {
      name = "text-encoding-0.6.4.tgz";
      path = fetchurl {
        name = "text-encoding-0.6.4.tgz";
        url  = "https://registry.yarnpkg.com/text-encoding/-/text-encoding-0.6.4.tgz";
        sha1 = "e399a982257a276dae428bb92845cb71bdc26d19";
      };
    }

    {
      name = "text-extensions-1.7.0.tgz";
      path = fetchurl {
        name = "text-extensions-1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/text-extensions/-/text-extensions-1.7.0.tgz";
        sha1 = "faaaba2625ed746d568a23e4d0aacd9bf08a8b39";
      };
    }

    {
      name = "text-hex-1.0.0.tgz";
      path = fetchurl {
        name = "text-hex-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/text-hex/-/text-hex-1.0.0.tgz";
        sha1 = "69dc9c1b17446ee79a92bf5b884bb4b9127506f5";
      };
    }

    {
      name = "text-table-0.2.0.tgz";
      path = fetchurl {
        name = "text-table-0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz";
        sha1 = "7f5ee823ae805207c00af2df4a84ec3fcfa570b4";
      };
    }

    {
      name = "textextensions-2.2.0.tgz";
      path = fetchurl {
        name = "textextensions-2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/textextensions/-/textextensions-2.2.0.tgz";
        sha1 = "38ac676151285b658654581987a0ce1a4490d286";
      };
    }

    {
      name = "throttleit-1.0.0.tgz";
      path = fetchurl {
        name = "throttleit-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/throttleit/-/throttleit-1.0.0.tgz";
        sha1 = "9e785836daf46743145a5984b6268d828528ac6c";
      };
    }

    {
      name = "through2-2.0.3.tgz";
      path = fetchurl {
        name = "through2-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/through2/-/through2-2.0.3.tgz";
        sha1 = "0004569b37c7c74ba39c43f3ced78d1ad94140be";
      };
    }

    {
      name = "through-2.3.8.tgz";
      path = fetchurl {
        name = "through-2.3.8.tgz";
        url  = "https://registry.yarnpkg.com/through/-/through-2.3.8.tgz";
        sha1 = "0dd4c9ffaabc357960b1b724115d7e0e86a2e1f5";
      };
    }

    {
      name = "time-zone-1.0.0.tgz";
      path = fetchurl {
        name = "time-zone-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/time-zone/-/time-zone-1.0.0.tgz";
        sha1 = "99c5bf55958966af6d06d83bdf3800dc82faec5d";
      };
    }

    {
      name = "timed-out-4.0.1.tgz";
      path = fetchurl {
        name = "timed-out-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/timed-out/-/timed-out-4.0.1.tgz";
        sha1 = "f32eacac5a175bea25d7fab565ab3ed8741ef56f";
      };
    }

    {
      name = "timers-browserify-2.0.10.tgz";
      path = fetchurl {
        name = "timers-browserify-2.0.10.tgz";
        url  = "https://registry.yarnpkg.com/timers-browserify/-/timers-browserify-2.0.10.tgz";
        sha1 = "1d28e3d2aadf1d5a5996c4e9f95601cd053480ae";
      };
    }

    {
      name = "timespan-2.3.0.tgz";
      path = fetchurl {
        name = "timespan-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/timespan/-/timespan-2.3.0.tgz";
        sha1 = "4902ce040bd13d845c8f59b27e9d59bad6f39929";
      };
    }

    {
      name = "tiny-emitter-2.0.2.tgz";
      path = fetchurl {
        name = "tiny-emitter-2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/tiny-emitter/-/tiny-emitter-2.0.2.tgz";
        sha1 = "82d27468aca5ade8e5fd1e6d22b57dd43ebdfb7c";
      };
    }

    {
      name = "tiny-lr-1.1.1.tgz";
      path = fetchurl {
        name = "tiny-lr-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/tiny-lr/-/tiny-lr-1.1.1.tgz";
        sha1 = "9fa547412f238fedb068ee295af8b682c98b2aab";
      };
    }

    {
      name = "tiny-relative-date-1.3.0.tgz";
      path = fetchurl {
        name = "tiny-relative-date-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/tiny-relative-date/-/tiny-relative-date-1.3.0.tgz";
        sha1 = "fa08aad501ed730f31cc043181d995c39a935e07";
      };
    }

    {
      name = "tinycolor2-1.4.1.tgz";
      path = fetchurl {
        name = "tinycolor2-1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/tinycolor2/-/tinycolor2-1.4.1.tgz";
        sha1 = "f4fad333447bc0b07d4dc8e9209d8f39a8ac77e8";
      };
    }

    {
      name = "tmp-0.0.28.tgz";
      path = fetchurl {
        name = "tmp-0.0.28.tgz";
        url  = "https://registry.yarnpkg.com/tmp/-/tmp-0.0.28.tgz";
        sha1 = "172735b7f614ea7af39664fa84cf0de4e515d120";
      };
    }

    {
      name = "tmp-0.0.29.tgz";
      path = fetchurl {
        name = "tmp-0.0.29.tgz";
        url  = "https://registry.yarnpkg.com/tmp/-/tmp-0.0.29.tgz";
        sha1 = "f25125ff0dd9da3ccb0c2dd371ee1288bb9128c0";
      };
    }

    {
      name = "tmp-0.0.33.tgz";
      path = fetchurl {
        name = "tmp-0.0.33.tgz";
        url  = "https://registry.yarnpkg.com/tmp/-/tmp-0.0.33.tgz";
        sha1 = "6d34335889768d21b2bcda0aa277ced3b1bfadf9";
      };
    }

    {
      name = "tmpl-1.0.4.tgz";
      path = fetchurl {
        name = "tmpl-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/tmpl/-/tmpl-1.0.4.tgz";
        sha1 = "23640dd7b42d00433911140820e5cf440e521dd1";
      };
    }

    {
      name = "to-array-0.1.4.tgz";
      path = fetchurl {
        name = "to-array-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/to-array/-/to-array-0.1.4.tgz";
        sha1 = "17e6c11f73dd4f3d74cda7a4ff3238e9ad9bf890";
      };
    }

    {
      name = "to-arraybuffer-1.0.1.tgz";
      path = fetchurl {
        name = "to-arraybuffer-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz";
        sha1 = "7d229b1fcc637e466ca081180836a7aabff83f43";
      };
    }

    {
      name = "to-fast-properties-1.0.3.tgz";
      path = fetchurl {
        name = "to-fast-properties-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-1.0.3.tgz";
        sha1 = "b83571fa4d8c25b82e231b06e3a3055de4ca1a47";
      };
    }

    {
      name = "to-ico-1.1.5.tgz";
      path = fetchurl {
        name = "to-ico-1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/to-ico/-/to-ico-1.1.5.tgz";
        sha1 = "1d32da5f2c90922edee6b686d610c54527b5a8d5";
      };
    }

    {
      name = "to-object-path-0.3.0.tgz";
      path = fetchurl {
        name = "to-object-path-0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/to-object-path/-/to-object-path-0.3.0.tgz";
        sha1 = "297588b7b0e7e0ac08e04e672f85c1f4999e17af";
      };
    }

    {
      name = "to-regex-range-2.1.1.tgz";
      path = fetchurl {
        name = "to-regex-range-2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-2.1.1.tgz";
        sha1 = "7c80c17b9dfebe599e27367e0d4dd5590141db38";
      };
    }

    {
      name = "to-regex-3.0.2.tgz";
      path = fetchurl {
        name = "to-regex-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/to-regex/-/to-regex-3.0.2.tgz";
        sha1 = "13cfdd9b336552f30b51f33a8ae1b42a7a7599ce";
      };
    }

    {
      name = "tough-cookie-2.4.3.tgz";
      path = fetchurl {
        name = "tough-cookie-2.4.3.tgz";
        url  = "https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.4.3.tgz";
        sha1 = "53f36da3f47783b0925afa06ff9f3b165280f781";
      };
    }

    {
      name = "tough-cookie-2.3.4.tgz";
      path = fetchurl {
        name = "tough-cookie-2.3.4.tgz";
        url  = "https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.3.4.tgz";
        sha1 = "ec60cee38ac675063ffc97a5c18970578ee83655";
      };
    }

    {
      name = "tr46-1.0.1.tgz";
      path = fetchurl {
        name = "tr46-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/tr46/-/tr46-1.0.1.tgz";
        sha1 = "a8b13fd6bfd2489519674ccde55ba3693b706d09";
      };
    }

    {
      name = "traverse-0.6.6.tgz";
      path = fetchurl {
        name = "traverse-0.6.6.tgz";
        url  = "https://registry.yarnpkg.com/traverse/-/traverse-0.6.6.tgz";
        sha1 = "cbdf560fd7b9af632502fed40f918c157ea97137";
      };
    }

    {
      name = "tree-sync-1.2.2.tgz";
      path = fetchurl {
        name = "tree-sync-1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/tree-sync/-/tree-sync-1.2.2.tgz";
        sha1 = "2cf76b8589f59ffedb58db5a3ac7cb013d0158b7";
      };
    }

    {
      name = "trim-newlines-1.0.0.tgz";
      path = fetchurl {
        name = "trim-newlines-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/trim-newlines/-/trim-newlines-1.0.0.tgz";
        sha1 = "5887966bb582a4503a41eb524f7d35011815a613";
      };
    }

    {
      name = "trim-newlines-2.0.0.tgz";
      path = fetchurl {
        name = "trim-newlines-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/trim-newlines/-/trim-newlines-2.0.0.tgz";
        sha1 = "b403d0b91be50c331dfc4b82eeceb22c3de16d20";
      };
    }

    {
      name = "trim-off-newlines-1.0.1.tgz";
      path = fetchurl {
        name = "trim-off-newlines-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/trim-off-newlines/-/trim-off-newlines-1.0.1.tgz";
        sha1 = "9f9ba9d9efa8764c387698bcbfeb2c848f11adb3";
      };
    }

    {
      name = "trim-right-1.0.1.tgz";
      path = fetchurl {
        name = "trim-right-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/trim-right/-/trim-right-1.0.1.tgz";
        sha1 = "cb2e1203067e0c8de1f614094b9fe45704ea6003";
      };
    }

    {
      name = "trim-0.0.1.tgz";
      path = fetchurl {
        name = "trim-0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/trim/-/trim-0.0.1.tgz";
        sha1 = "5858547f6b290757ee95cccc666fb50084c460dd";
      };
    }

    {
      name = "triple-beam-1.3.0.tgz";
      path = fetchurl {
        name = "triple-beam-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/triple-beam/-/triple-beam-1.3.0.tgz";
        sha1 = "a595214c7298db8339eeeee083e4d10bd8cb8dd9";
      };
    }

    {
      name = "true-case-path-1.0.3.tgz";
      path = fetchurl {
        name = "true-case-path-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/true-case-path/-/true-case-path-1.0.3.tgz";
        sha1 = "f813b5a8c86b40da59606722b144e3225799f47d";
      };
    }

    {
      name = "tslib-1.9.3.tgz";
      path = fetchurl {
        name = "tslib-1.9.3.tgz";
        url  = "https://registry.yarnpkg.com/tslib/-/tslib-1.9.3.tgz";
        sha1 = "d7e4dd79245d85428c4d7e4822a79917954ca286";
      };
    }

    {
      name = "tty-browserify-0.0.0.tgz";
      path = fetchurl {
        name = "tty-browserify-0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/tty-browserify/-/tty-browserify-0.0.0.tgz";
        sha1 = "a157ba402da24e9bf957f9aa69d524eed42901a6";
      };
    }

    {
      name = "tunnel-agent-0.6.0.tgz";
      path = fetchurl {
        name = "tunnel-agent-0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/tunnel-agent/-/tunnel-agent-0.6.0.tgz";
        sha1 = "27a5dea06b36b04a0a9966774b290868f0fc40fd";
      };
    }

    {
      name = "tweetnacl-0.14.5.tgz";
      path = fetchurl {
        name = "tweetnacl-0.14.5.tgz";
        url  = "https://registry.yarnpkg.com/tweetnacl/-/tweetnacl-0.14.5.tgz";
        sha1 = "5ae68177f192d4456269d108afa93ff8743f4f64";
      };
    }

    {
      name = "type-check-0.3.2.tgz";
      path = fetchurl {
        name = "type-check-0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/type-check/-/type-check-0.3.2.tgz";
        sha1 = "5884cab512cf1d355e3fb784f30804b2b520db72";
      };
    }

    {
      name = "type-detect-4.0.8.tgz";
      path = fetchurl {
        name = "type-detect-4.0.8.tgz";
        url  = "https://registry.yarnpkg.com/type-detect/-/type-detect-4.0.8.tgz";
        sha1 = "7646fb5f18871cfbb7749e69bd39a6388eb7450c";
      };
    }

    {
      name = "type-is-1.6.16.tgz";
      path = fetchurl {
        name = "type-is-1.6.16.tgz";
        url  = "https://registry.yarnpkg.com/type-is/-/type-is-1.6.16.tgz";
        sha1 = "f89ce341541c672b25ee7ae3c73dee3b2be50194";
      };
    }

    {
      name = "typedarray-0.0.6.tgz";
      path = fetchurl {
        name = "typedarray-0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz";
        sha1 = "867ac74e3864187b1d3d47d996a78ec5c8830777";
      };
    }

    {
      name = "typescript-eslint-parser-16.0.1.tgz";
      path = fetchurl {
        name = "typescript-eslint-parser-16.0.1.tgz";
        url  = "https://registry.yarnpkg.com/typescript-eslint-parser/-/typescript-eslint-parser-16.0.1.tgz";
        sha1 = "b40681c7043b222b9772748b700a000b241c031b";
      };
    }

    {
      name = "typescript-2.9.2.tgz";
      path = fetchurl {
        name = "typescript-2.9.2.tgz";
        url  = "https://registry.yarnpkg.com/typescript/-/typescript-2.9.2.tgz";
        sha1 = "1cbf61d05d6b96269244eb6a3bce4bd914e0f00c";
      };
    }

    {
      name = "uc.micro-1.0.5.tgz";
      path = fetchurl {
        name = "uc.micro-1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/uc.micro/-/uc.micro-1.0.5.tgz";
        sha1 = "0c65f15f815aa08b560a61ce8b4db7ffc3f45376";
      };
    }

    {
      name = "uglify-es-3.3.9.tgz";
      path = fetchurl {
        name = "uglify-es-3.3.9.tgz";
        url  = "https://registry.yarnpkg.com/uglify-es/-/uglify-es-3.3.9.tgz";
        sha1 = "0c1c4f0700bed8dbc124cdb304d2592ca203e677";
      };
    }

    {
      name = "uglify-js-1.3.5.tgz";
      path = fetchurl {
        name = "uglify-js-1.3.5.tgz";
        url  = "http://registry.npmjs.org/uglify-js/-/uglify-js-1.3.5.tgz";
        sha1 = "4b5bfff9186effbaa888e4c9e94bd9fc4c94929d";
      };
    }

    {
      name = "uglify-js-3.4.9.tgz";
      path = fetchurl {
        name = "uglify-js-3.4.9.tgz";
        url  = "https://registry.yarnpkg.com/uglify-js/-/uglify-js-3.4.9.tgz";
        sha1 = "af02f180c1207d76432e473ed24a28f4a782bae3";
      };
    }

    {
      name = "uglifyjs-webpack-plugin-1.3.0.tgz";
      path = fetchurl {
        name = "uglifyjs-webpack-plugin-1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/uglifyjs-webpack-plugin/-/uglifyjs-webpack-plugin-1.3.0.tgz";
        sha1 = "75f548160858163a08643e086d5fefe18a5d67de";
      };
    }

    {
      name = "uid-number-0.0.6.tgz";
      path = fetchurl {
        name = "uid-number-0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/uid-number/-/uid-number-0.0.6.tgz";
        sha1 = "0ea10e8035e8eb5b8e4449f06da1c730663baa81";
      };
    }

    {
      name = "ultron-1.1.1.tgz";
      path = fetchurl {
        name = "ultron-1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ultron/-/ultron-1.1.1.tgz";
        sha1 = "9fe1536a10a664a65266a1e3ccf85fd36302bc9c";
      };
    }

    {
      name = "umask-1.1.0.tgz";
      path = fetchurl {
        name = "umask-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/umask/-/umask-1.1.0.tgz";
        sha1 = "f29cebf01df517912bb58ff9c4e50fde8e33320d";
      };
    }

    {
      name = "underscore.string-3.3.4.tgz";
      path = fetchurl {
        name = "underscore.string-3.3.4.tgz";
        url  = "https://registry.yarnpkg.com/underscore.string/-/underscore.string-3.3.4.tgz";
        sha1 = "2c2a3f9f83e64762fdc45e6ceac65142864213db";
      };
    }

    {
      name = "underscore-1.9.1.tgz";
      path = fetchurl {
        name = "underscore-1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/underscore/-/underscore-1.9.1.tgz";
        sha1 = "06dce34a0e68a7babc29b365b8e74b8925203961";
      };
    }

    {
      name = "underscore-1.6.0.tgz";
      path = fetchurl {
        name = "underscore-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/underscore/-/underscore-1.6.0.tgz";
        sha1 = "8b38b10cacdef63337b8b24e4ff86d45aea529a8";
      };
    }

    {
      name = "union-value-1.0.0.tgz";
      path = fetchurl {
        name = "union-value-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/union-value/-/union-value-1.0.0.tgz";
        sha1 = "5c71c34cb5bad5dcebe3ea0cd08207ba5aa1aea4";
      };
    }

    {
      name = "unique-filename-1.1.0.tgz";
      path = fetchurl {
        name = "unique-filename-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/unique-filename/-/unique-filename-1.1.0.tgz";
        sha1 = "d05f2fe4032560871f30e93cbe735eea201514f3";
      };
    }

    {
      name = "unique-slug-2.0.0.tgz";
      path = fetchurl {
        name = "unique-slug-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unique-slug/-/unique-slug-2.0.0.tgz";
        sha1 = "db6676e7c7cc0629878ff196097c78855ae9f4ab";
      };
    }

    {
      name = "unique-string-1.0.0.tgz";
      path = fetchurl {
        name = "unique-string-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unique-string/-/unique-string-1.0.0.tgz";
        sha1 = "9e1057cca851abb93398f8b33ae187b99caec11a";
      };
    }

    {
      name = "universalify-0.1.2.tgz";
      path = fetchurl {
        name = "universalify-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz";
        sha1 = "b646f69be3942dabcecc9d6639c80dc105efaa66";
      };
    }

    {
      name = "unpipe-1.0.0.tgz";
      path = fetchurl {
        name = "unpipe-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unpipe/-/unpipe-1.0.0.tgz";
        sha1 = "b2bf4ee8514aae6165b4817829d21b2ef49904ec";
      };
    }

    {
      name = "unset-value-1.0.0.tgz";
      path = fetchurl {
        name = "unset-value-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unset-value/-/unset-value-1.0.0.tgz";
        sha1 = "8376873f7d2335179ffb1e6fc3a8ed0dfc8ab559";
      };
    }

    {
      name = "untildify-2.1.0.tgz";
      path = fetchurl {
        name = "untildify-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/untildify/-/untildify-2.1.0.tgz";
        sha1 = "17eb2807987f76952e9c0485fc311d06a826a2e0";
      };
    }

    {
      name = "unzip-response-2.0.1.tgz";
      path = fetchurl {
        name = "unzip-response-2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/unzip-response/-/unzip-response-2.0.1.tgz";
        sha1 = "d2f0f737d16b0615e72a6935ed04214572d56f97";
      };
    }

    {
      name = "upath-1.1.0.tgz";
      path = fetchurl {
        name = "upath-1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/upath/-/upath-1.1.0.tgz";
        sha1 = "35256597e46a581db4793d0ce47fa9aebfc9fabd";
      };
    }

    {
      name = "update-notifier-2.5.0.tgz";
      path = fetchurl {
        name = "update-notifier-2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/update-notifier/-/update-notifier-2.5.0.tgz";
        sha1 = "d0744593e13f161e406acb1d9408b72cad08aff6";
      };
    }

    {
      name = "uri-js-4.2.2.tgz";
      path = fetchurl {
        name = "uri-js-4.2.2.tgz";
        url  = "https://registry.yarnpkg.com/uri-js/-/uri-js-4.2.2.tgz";
        sha1 = "94c540e1ff772956e2299507c010aea6c8838eb0";
      };
    }

    {
      name = "urix-0.1.0.tgz";
      path = fetchurl {
        name = "urix-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/urix/-/urix-0.1.0.tgz";
        sha1 = "da937f7a62e21fec1fd18d49b35c2935067a6c72";
      };
    }

    {
      name = "url-join-4.0.0.tgz";
      path = fetchurl {
        name = "url-join-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/url-join/-/url-join-4.0.0.tgz";
        sha1 = "4d3340e807d3773bda9991f8305acdcc2a665d2a";
      };
    }

    {
      name = "url-parse-lax-1.0.0.tgz";
      path = fetchurl {
        name = "url-parse-lax-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/url-parse-lax/-/url-parse-lax-1.0.0.tgz";
        sha1 = "7af8f303645e9bd79a272e7a14ac68bc0609da73";
      };
    }

    {
      name = "url-regex-3.2.0.tgz";
      path = fetchurl {
        name = "url-regex-3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/url-regex/-/url-regex-3.2.0.tgz";
        sha1 = "dbad1e0c9e29e105dd0b1f09f6862f7fdb482724";
      };
    }

    {
      name = "url-template-2.0.8.tgz";
      path = fetchurl {
        name = "url-template-2.0.8.tgz";
        url  = "https://registry.yarnpkg.com/url-template/-/url-template-2.0.8.tgz";
        sha1 = "fc565a3cccbff7730c775f5641f9555791439f21";
      };
    }

    {
      name = "url-0.11.0.tgz";
      path = fetchurl {
        name = "url-0.11.0.tgz";
        url  = "https://registry.yarnpkg.com/url/-/url-0.11.0.tgz";
        sha1 = "3838e97cfc60521eb73c525a8e55bfdd9e2e28f1";
      };
    }

    {
      name = "use-3.1.1.tgz";
      path = fetchurl {
        name = "use-3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/use/-/use-3.1.1.tgz";
        sha1 = "d50c8cac79a19fbc20f2911f56eb973f4e10070f";
      };
    }

    {
      name = "user-info-1.0.0.tgz";
      path = fetchurl {
        name = "user-info-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/user-info/-/user-info-1.0.0.tgz";
        sha1 = "81c82b7ed63e674c2475667653413b3c76fde239";
      };
    }

    {
      name = "username-sync-1.0.1.tgz";
      path = fetchurl {
        name = "username-sync-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/username-sync/-/username-sync-1.0.1.tgz";
        sha1 = "1cde87eefcf94b8822984d938ba2b797426dae1f";
      };
    }

    {
      name = "username-1.0.1.tgz";
      path = fetchurl {
        name = "username-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/username/-/username-1.0.1.tgz";
        sha1 = "e1f72295e3e58e06f002c6327ce06897a99cd67f";
      };
    }

    {
      name = "util-deprecate-1.0.2.tgz";
      path = fetchurl {
        name = "util-deprecate-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
    }

    {
      name = "util-extend-1.0.3.tgz";
      path = fetchurl {
        name = "util-extend-1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/util-extend/-/util-extend-1.0.3.tgz";
        sha1 = "a7c216d267545169637b3b6edc6ca9119e2ff93f";
      };
    }

    {
      name = "util.promisify-1.0.0.tgz";
      path = fetchurl {
        name = "util.promisify-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/util.promisify/-/util.promisify-1.0.0.tgz";
        sha1 = "440f7165a459c9a16dc145eb8e72f35687097030";
      };
    }

    {
      name = "util-0.10.3.tgz";
      path = fetchurl {
        name = "util-0.10.3.tgz";
        url  = "https://registry.yarnpkg.com/util/-/util-0.10.3.tgz";
        sha1 = "7afb1afe50805246489e3db7fe0ed379336ac0f9";
      };
    }

    {
      name = "util-0.10.4.tgz";
      path = fetchurl {
        name = "util-0.10.4.tgz";
        url  = "https://registry.yarnpkg.com/util/-/util-0.10.4.tgz";
        sha1 = "3aa0125bfe668a4672de58857d3ace27ecb76901";
      };
    }

    {
      name = "utils-merge-1.0.1.tgz";
      path = fetchurl {
        name = "utils-merge-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/utils-merge/-/utils-merge-1.0.1.tgz";
        sha1 = "9f95710f50a267947b2ccc124741c1028427e713";
      };
    }

    {
      name = "uuid-3.3.2.tgz";
      path = fetchurl {
        name = "uuid-3.3.2.tgz";
        url  = "https://registry.yarnpkg.com/uuid/-/uuid-3.3.2.tgz";
        sha1 = "1b4af4955eb3077c501c23872fc6513811587131";
      };
    }

    {
      name = "validate-npm-package-license-3.0.4.tgz";
      path = fetchurl {
        name = "validate-npm-package-license-3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz";
        sha1 = "fc91f6b9c7ba15c857f4cb2c5defeec39d4f410a";
      };
    }

    {
      name = "validate-npm-package-name-3.0.0.tgz";
      path = fetchurl {
        name = "validate-npm-package-name-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/validate-npm-package-name/-/validate-npm-package-name-3.0.0.tgz";
        sha1 = "5fa912d81eb7d0c74afc140de7317f0ca7df437e";
      };
    }

    {
      name = "vary-1.1.2.tgz";
      path = fetchurl {
        name = "vary-1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/vary/-/vary-1.1.2.tgz";
        sha1 = "2299f02c6ded30d4a5961b0b9f74524a18f634fc";
      };
    }

    {
      name = "verror-1.10.0.tgz";
      path = fetchurl {
        name = "verror-1.10.0.tgz";
        url  = "https://registry.yarnpkg.com/verror/-/verror-1.10.0.tgz";
        sha1 = "3a105ca17053af55d6e270c1f8288682e18da400";
      };
    }

    {
      name = "vinyl-1.2.0.tgz";
      path = fetchurl {
        name = "vinyl-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/vinyl/-/vinyl-1.2.0.tgz";
        sha1 = "5c88036cf565e5df05558bfc911f8656df218884";
      };
    }

    {
      name = "vm-browserify-0.0.4.tgz";
      path = fetchurl {
        name = "vm-browserify-0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/vm-browserify/-/vm-browserify-0.0.4.tgz";
        sha1 = "5d7ea45bbef9e4a6ff65f95438e0a87c357d5a73";
      };
    }

    {
      name = "vue-eslint-parser-2.0.3.tgz";
      path = fetchurl {
        name = "vue-eslint-parser-2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/vue-eslint-parser/-/vue-eslint-parser-2.0.3.tgz";
        sha1 = "c268c96c6d94cfe3d938a5f7593959b0ca3360d1";
      };
    }

    {
      name = "w3c-hr-time-1.0.1.tgz";
      path = fetchurl {
        name = "w3c-hr-time-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/w3c-hr-time/-/w3c-hr-time-1.0.1.tgz";
        sha1 = "82ac2bff63d950ea9e3189a58a65625fedf19045";
      };
    }

    {
      name = "walk-sync-0.3.2.tgz";
      path = fetchurl {
        name = "walk-sync-0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/walk-sync/-/walk-sync-0.3.2.tgz";
        sha1 = "4827280afc42d0e035367c4a4e31eeac0d136f75";
      };
    }

    {
      name = "walk-sync-0.1.3.tgz";
      path = fetchurl {
        name = "walk-sync-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/walk-sync/-/walk-sync-0.1.3.tgz";
        sha1 = "8a07261a00bda6cfb1be25e9f100fad57546f583";
      };
    }

    {
      name = "walk-sync-0.2.7.tgz";
      path = fetchurl {
        name = "walk-sync-0.2.7.tgz";
        url  = "https://registry.yarnpkg.com/walk-sync/-/walk-sync-0.2.7.tgz";
        sha1 = "b49be4ee6867657aeb736978b56a29d10fa39969";
      };
    }

    {
      name = "walk-sync-0.3.3.tgz";
      path = fetchurl {
        name = "walk-sync-0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/walk-sync/-/walk-sync-0.3.3.tgz";
        sha1 = "1e9f12cd4fe6e0e6d4a0715b5cc7e30711d43cd1";
      };
    }

    {
      name = "walker-1.0.7.tgz";
      path = fetchurl {
        name = "walker-1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/walker/-/walker-1.0.7.tgz";
        sha1 = "2f7f9b8fd10d677262b18a884e28d19618e028fb";
      };
    }

    {
      name = "watch-detector-0.1.0.tgz";
      path = fetchurl {
        name = "watch-detector-0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/watch-detector/-/watch-detector-0.1.0.tgz";
        sha1 = "e37b410d149e2a8bf263a4f8b71e2f667633dbf8";
      };
    }

    {
      name = "watch-0.18.0.tgz";
      path = fetchurl {
        name = "watch-0.18.0.tgz";
        url  = "https://registry.yarnpkg.com/watch/-/watch-0.18.0.tgz";
        sha1 = "28095476c6df7c90c963138990c0a5423eb4b986";
      };
    }

    {
      name = "watchpack-1.6.0.tgz";
      path = fetchurl {
        name = "watchpack-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/watchpack/-/watchpack-1.6.0.tgz";
        sha1 = "4bc12c2ebe8aa277a71f1d3f14d685c7b446cd00";
      };
    }

    {
      name = "wcwidth-1.0.1.tgz";
      path = fetchurl {
        name = "wcwidth-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/wcwidth/-/wcwidth-1.0.1.tgz";
        sha1 = "f0b0dcf915bc5ff1528afadb2c0e17b532da2fe8";
      };
    }

    {
      name = "webidl-conversions-4.0.2.tgz";
      path = fetchurl {
        name = "webidl-conversions-4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-4.0.2.tgz";
        sha1 = "a855980b1f0b6b359ba1d5d9fb39ae941faa63ad";
      };
    }

    {
      name = "webpack-sources-1.2.0.tgz";
      path = fetchurl {
        name = "webpack-sources-1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-1.2.0.tgz";
        sha1 = "18181e0d013fce096faf6f8e6d41eeffffdceac2";
      };
    }

    {
      name = "webpack-4.17.2.tgz";
      path = fetchurl {
        name = "webpack-4.17.2.tgz";
        url  = "https://registry.yarnpkg.com/webpack/-/webpack-4.17.2.tgz";
        sha1 = "49feb20205bd15f0a5f1fe0a12097d5d9931878d";
      };
    }

    {
      name = "websocket-driver-0.7.0.tgz";
      path = fetchurl {
        name = "websocket-driver-0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/websocket-driver/-/websocket-driver-0.7.0.tgz";
        sha1 = "0caf9d2d755d93aee049d4bdd0d3fe2cca2a24eb";
      };
    }

    {
      name = "websocket-extensions-0.1.3.tgz";
      path = fetchurl {
        name = "websocket-extensions-0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/websocket-extensions/-/websocket-extensions-0.1.3.tgz";
        sha1 = "5d2ff22977003ec687a4b87073dfbbac146ccf29";
      };
    }

    {
      name = "whatwg-encoding-1.0.4.tgz";
      path = fetchurl {
        name = "whatwg-encoding-1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/whatwg-encoding/-/whatwg-encoding-1.0.4.tgz";
        sha1 = "63fb016b7435b795d9025632c086a5209dbd2621";
      };
    }

    {
      name = "whatwg-fetch-2.0.4.tgz";
      path = fetchurl {
        name = "whatwg-fetch-2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/whatwg-fetch/-/whatwg-fetch-2.0.4.tgz";
        sha1 = "dde6a5df315f9d39991aa17621853d720b85566f";
      };
    }

    {
      name = "whatwg-mimetype-2.1.0.tgz";
      path = fetchurl {
        name = "whatwg-mimetype-2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/whatwg-mimetype/-/whatwg-mimetype-2.1.0.tgz";
        sha1 = "f0f21d76cbba72362eb609dbed2a30cd17fcc7d4";
      };
    }

    {
      name = "whatwg-url-6.5.0.tgz";
      path = fetchurl {
        name = "whatwg-url-6.5.0.tgz";
        url  = "https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-6.5.0.tgz";
        sha1 = "f2df02bff176fd65070df74ad5ccbb5a199965a8";
      };
    }

    {
      name = "whatwg-url-7.0.0.tgz";
      path = fetchurl {
        name = "whatwg-url-7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-7.0.0.tgz";
        sha1 = "fde926fa54a599f3adf82dff25a9f7be02dc6edd";
      };
    }

    {
      name = "which-module-1.0.0.tgz";
      path = fetchurl {
        name = "which-module-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/which-module/-/which-module-1.0.0.tgz";
        sha1 = "bba63ca861948994ff307736089e3b96026c2a4f";
      };
    }

    {
      name = "which-module-2.0.0.tgz";
      path = fetchurl {
        name = "which-module-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/which-module/-/which-module-2.0.0.tgz";
        sha1 = "d9ef07dce77b9902b8a3a8fa4b31c3e3f7e6e87a";
      };
    }

    {
      name = "which-1.3.1.tgz";
      path = fetchurl {
        name = "which-1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-1.3.1.tgz";
        sha1 = "a45043d54f5805316da8d62f9f50918d3da70b0a";
      };
    }

    {
      name = "wide-align-1.1.3.tgz";
      path = fetchurl {
        name = "wide-align-1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.3.tgz";
        sha1 = "ae074e6bdc0c14a431e804e624549c633b000457";
      };
    }

    {
      name = "widest-line-2.0.0.tgz";
      path = fetchurl {
        name = "widest-line-2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/widest-line/-/widest-line-2.0.0.tgz";
        sha1 = "0142a4e8a243f8882c0233aa0e0281aa76152273";
      };
    }

    {
      name = "window-size-0.1.4.tgz";
      path = fetchurl {
        name = "window-size-0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/window-size/-/window-size-0.1.4.tgz";
        sha1 = "f8e1aa1ee5a53ec5bf151ffa09742a6ad7697876";
      };
    }

    {
      name = "winston-transport-4.2.0.tgz";
      path = fetchurl {
        name = "winston-transport-4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/winston-transport/-/winston-transport-4.2.0.tgz";
        sha1 = "a20be89edf2ea2ca39ba25f3e50344d73e6520e5";
      };
    }

    {
      name = "winston-3.1.0.tgz";
      path = fetchurl {
        name = "winston-3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/winston/-/winston-3.1.0.tgz";
        sha1 = "80724376aef164e024f316100d5b178d78ac5331";
      };
    }

    {
      name = "wordwrap-0.0.3.tgz";
      path = fetchurl {
        name = "wordwrap-0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/wordwrap/-/wordwrap-0.0.3.tgz";
        sha1 = "a3d5da6cd5c0bc0008d37234bbaf1bed63059107";
      };
    }

    {
      name = "wordwrap-1.0.0.tgz";
      path = fetchurl {
        name = "wordwrap-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/wordwrap/-/wordwrap-1.0.0.tgz";
        sha1 = "27584810891456a4171c8d0226441ade90cbcaeb";
      };
    }

    {
      name = "worker-farm-1.6.0.tgz";
      path = fetchurl {
        name = "worker-farm-1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/worker-farm/-/worker-farm-1.6.0.tgz";
        sha1 = "aecc405976fab5a95526180846f0dba288f3a4a0";
      };
    }

    {
      name = "workerpool-2.3.2.tgz";
      path = fetchurl {
        name = "workerpool-2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/workerpool/-/workerpool-2.3.2.tgz";
        sha1 = "6bb17f31293e6b1e5e8dcdd5c2ad9122f471aaf3";
      };
    }

    {
      name = "wrap-ansi-2.1.0.tgz";
      path = fetchurl {
        name = "wrap-ansi-2.1.0.tgz";
        url  = "http://registry.npmjs.org/wrap-ansi/-/wrap-ansi-2.1.0.tgz";
        sha1 = "d8fc3d284dd05794fe84973caecdd1cf824fdd85";
      };
    }

    {
      name = "wrappy-1.0.2.tgz";
      path = fetchurl {
        name = "wrappy-1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz";
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    }

    {
      name = "wrench-1.3.9.tgz";
      path = fetchurl {
        name = "wrench-1.3.9.tgz";
        url  = "https://registry.yarnpkg.com/wrench/-/wrench-1.3.9.tgz";
        sha1 = "6f13ec35145317eb292ca5f6531391b244111411";
      };
    }

    {
      name = "write-file-atomic-2.3.0.tgz";
      path = fetchurl {
        name = "write-file-atomic-2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-2.3.0.tgz";
        sha1 = "1ff61575c2e2a4e8e510d6fa4e243cce183999ab";
      };
    }

    {
      name = "write-0.2.1.tgz";
      path = fetchurl {
        name = "write-0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/write/-/write-0.2.1.tgz";
        sha1 = "5fc03828e264cea3fe91455476f7a3c566cb0757";
      };
    }

    {
      name = "ws-5.2.2.tgz";
      path = fetchurl {
        name = "ws-5.2.2.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-5.2.2.tgz";
        sha1 = "dffef14866b8e8dc9133582514d1befaf96e980f";
      };
    }

    {
      name = "ws-3.3.3.tgz";
      path = fetchurl {
        name = "ws-3.3.3.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-3.3.3.tgz";
        sha1 = "f1cf84fe2d5e901ebce94efaece785f187a228f2";
      };
    }

    {
      name = "xdg-basedir-3.0.0.tgz";
      path = fetchurl {
        name = "xdg-basedir-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-3.0.0.tgz";
        sha1 = "496b2cc109eca8dbacfe2dc72b603c17c5870ad4";
      };
    }

    {
      name = "xhr-2.5.0.tgz";
      path = fetchurl {
        name = "xhr-2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/xhr/-/xhr-2.5.0.tgz";
        sha1 = "bed8d1676d5ca36108667692b74b316c496e49dd";
      };
    }

    {
      name = "xml-name-validator-3.0.0.tgz";
      path = fetchurl {
        name = "xml-name-validator-3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/xml-name-validator/-/xml-name-validator-3.0.0.tgz";
        sha1 = "6ae73e06de4d8c6e47f9fb181f78d648ad457c6a";
      };
    }

    {
      name = "xml-parse-from-string-1.0.1.tgz";
      path = fetchurl {
        name = "xml-parse-from-string-1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/xml-parse-from-string/-/xml-parse-from-string-1.0.1.tgz";
        sha1 = "a9029e929d3dbcded169f3c6e28238d95a5d5a28";
      };
    }

    {
      name = "xml2js-0.4.19.tgz";
      path = fetchurl {
        name = "xml2js-0.4.19.tgz";
        url  = "https://registry.yarnpkg.com/xml2js/-/xml2js-0.4.19.tgz";
        sha1 = "686c20f213209e94abf0d1bcf1efaa291c7827a7";
      };
    }

    {
      name = "xmlbuilder-9.0.7.tgz";
      path = fetchurl {
        name = "xmlbuilder-9.0.7.tgz";
        url  = "https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-9.0.7.tgz";
        sha1 = "132ee63d2ec5565c557e20f4c22df9aca686b10d";
      };
    }

    {
      name = "xmldom-0.1.27.tgz";
      path = fetchurl {
        name = "xmldom-0.1.27.tgz";
        url  = "https://registry.yarnpkg.com/xmldom/-/xmldom-0.1.27.tgz";
        sha1 = "d501f97b3bdb403af8ef9ecc20573187aadac0e9";
      };
    }

    {
      name = "xmlhttprequest-ssl-1.5.5.tgz";
      path = fetchurl {
        name = "xmlhttprequest-ssl-1.5.5.tgz";
        url  = "https://registry.yarnpkg.com/xmlhttprequest-ssl/-/xmlhttprequest-ssl-1.5.5.tgz";
        sha1 = "c2876b06168aadc40e57d97e81191ac8f4398b3e";
      };
    }

    {
      name = "xregexp-4.0.0.tgz";
      path = fetchurl {
        name = "xregexp-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/xregexp/-/xregexp-4.0.0.tgz";
        sha1 = "e698189de49dd2a18cc5687b05e17c8e43943020";
      };
    }

    {
      name = "xstate-3.3.3.tgz";
      path = fetchurl {
        name = "xstate-3.3.3.tgz";
        url  = "https://registry.yarnpkg.com/xstate/-/xstate-3.3.3.tgz";
        sha1 = "64177cd4473d4c2424b3df7d2434d835404b09a9";
      };
    }

    {
      name = "xtend-4.0.1.tgz";
      path = fetchurl {
        name = "xtend-4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/xtend/-/xtend-4.0.1.tgz";
        sha1 = "a5c6d532be656e23db820efb943a1f04998d63af";
      };
    }

    {
      name = "y18n-3.2.1.tgz";
      path = fetchurl {
        name = "y18n-3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/y18n/-/y18n-3.2.1.tgz";
        sha1 = "6d15fba884c08679c0d77e88e7759e811e07fa41";
      };
    }

    {
      name = "y18n-4.0.0.tgz";
      path = fetchurl {
        name = "y18n-4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/y18n/-/y18n-4.0.0.tgz";
        sha1 = "95ef94f85ecc81d007c264e190a120f0a3c8566b";
      };
    }

    {
      name = "yallist-2.1.2.tgz";
      path = fetchurl {
        name = "yallist-2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-2.1.2.tgz";
        sha1 = "1c11f9218f076089a47dd512f93c6699a6a81d52";
      };
    }

    {
      name = "yallist-3.0.2.tgz";
      path = fetchurl {
        name = "yallist-3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-3.0.2.tgz";
        sha1 = "8452b4bb7e83c7c188d8041c1a837c773d6d8bb9";
      };
    }

    {
      name = "yam-0.0.24.tgz";
      path = fetchurl {
        name = "yam-0.0.24.tgz";
        url  = "https://registry.yarnpkg.com/yam/-/yam-0.0.24.tgz";
        sha1 = "11e9630444735f66a561d29221407de6d037cd95";
      };
    }

    {
      name = "yargs-parser-10.1.0.tgz";
      path = fetchurl {
        name = "yargs-parser-10.1.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-10.1.0.tgz";
        sha1 = "7202265b89f7e9e9f2e5765e0fe735a905edbaa8";
      };
    }

    {
      name = "yargs-parser-5.0.0.tgz";
      path = fetchurl {
        name = "yargs-parser-5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-5.0.0.tgz";
        sha1 = "275ecf0d7ffe05c77e64e7c86e4cd94bf0e1228a";
      };
    }

    {
      name = "yargs-parser-8.1.0.tgz";
      path = fetchurl {
        name = "yargs-parser-8.1.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-8.1.0.tgz";
        sha1 = "f1376a33b6629a5d063782944da732631e966950";
      };
    }

    {
      name = "yargs-parser-9.0.2.tgz";
      path = fetchurl {
        name = "yargs-parser-9.0.2.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-9.0.2.tgz";
        sha1 = "9ccf6a43460fe4ed40a9bb68f48d43b8a68cc077";
      };
    }

    {
      name = "yargs-10.0.3.tgz";
      path = fetchurl {
        name = "yargs-10.0.3.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-10.0.3.tgz";
        sha1 = "6542debd9080ad517ec5048fb454efe9e4d4aaae";
      };
    }

    {
      name = "yargs-11.1.0.tgz";
      path = fetchurl {
        name = "yargs-11.1.0.tgz";
        url  = "http://registry.npmjs.org/yargs/-/yargs-11.1.0.tgz";
        sha1 = "90b869934ed6e871115ea2ff58b03f4724ed2d77";
      };
    }

    {
      name = "yargs-12.0.2.tgz";
      path = fetchurl {
        name = "yargs-12.0.2.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-12.0.2.tgz";
        sha1 = "fe58234369392af33ecbef53819171eff0f5aadc";
      };
    }

    {
      name = "yargs-3.32.0.tgz";
      path = fetchurl {
        name = "yargs-3.32.0.tgz";
        url  = "http://registry.npmjs.org/yargs/-/yargs-3.32.0.tgz";
        sha1 = "03088e9ebf9e756b69751611d2a5ef591482c995";
      };
    }

    {
      name = "yargs-7.1.0.tgz";
      path = fetchurl {
        name = "yargs-7.1.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-7.1.0.tgz";
        sha1 = "6ba318eb16961727f5d284f8ea003e8d6154d0c8";
      };
    }

    {
      name = "yauzl-2.4.1.tgz";
      path = fetchurl {
        name = "yauzl-2.4.1.tgz";
        url  = "https://registry.yarnpkg.com/yauzl/-/yauzl-2.4.1.tgz";
        sha1 = "9528f442dab1b2284e58b4379bb194e22e0c4005";
      };
    }

    {
      name = "yeast-0.1.2.tgz";
      path = fetchurl {
        name = "yeast-0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/yeast/-/yeast-0.1.2.tgz";
        sha1 = "008e06d8094320c372dbc2f8ed76a0ca6c8ac419";
      };
    }
  ];
}
