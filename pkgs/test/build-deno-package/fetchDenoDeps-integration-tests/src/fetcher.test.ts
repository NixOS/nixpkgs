import { argsToCommand, assertEq, dec, runTests } from "./utils.ts";
import type { Fixture, SetupFn, Test, Vars, VirtualFS } from "./types.d.ts";

type FetcherFixture = {
  inJsrJsonContent: string;
  inNpmJsonContent: string;
  inHttpsJsonContent: string;
  inServerFS: VirtualFS;
  outJsrJsonContent: string;
  outHttpsJsonContent: string;
  outNpmJsonContent: string;
  outFetchedFilesFS: VirtualFS;
  outStdout?: string;
  outStderr?: string;
};

type ServerConfig = {
  host: string;
  port: string;
  root: string;
};

function startMockServer(
  serverConfig: ServerConfig,
): SetupFn {
  return async () => {
    await Deno.mkdir(serverConfig.root, { recursive: true });
    const command = argsToCommand([
      "static-web-server",
      "--host",
      serverConfig.host,
      "--port",
      serverConfig.port,
      "--root",
      serverConfig.root,
    ], { stdout: "piped", stderr: "piped", stdin: "piped" });
    console.log("starting server");
    const p = command.spawn();
    p.stdin.close();
    const teardownFn = async () => {
      console.log("teardown server");
      p.kill();

      const { code, stdout, stderr } = await p.output();
      console.log(dec.decode(stdout));
      console.log(dec.decode(stderr));
      // assertEq(code, 0);

      console.log("teardown server done");
    };
    return teardownFn;
  };
}

const serverConfig = {
  host: "127.0.0.1",
  port: "8080",
  root: "./serve",
};

const PLACEHOLDER = "$DOMAIN$";

function fixtureFrom(f: FetcherFixture): Omit<Test, "name"> {
  return {
    fixture: _fixtureFrom(f, serverConfig),
    setupFn: startMockServer(serverConfig),
  };
}

function checkOutFetchedFilesFs(f: FetcherFixture) {
  function getOutPaths(jsonContent: string): Array<string> {
    return (JSON.parse(jsonContent) as Array<any>).map((e: any) =>
      e.outPath as string
    );
  }
  const fetchedFilesFsExpected = [
    ...getOutPaths(f.outJsrJsonContent),
    ...getOutPaths(f.outHttpsJsonContent),
    ...getOutPaths(f.outNpmJsonContent),
  ].sort();
  const fetchedFilesFsFromFixture = Object.keys(f.outFetchedFilesFS).sort();
  assertEq(
    fetchedFilesFsExpected,
    fetchedFilesFsFromFixture,
    "outFetchedFilesFS specified in fixture, do not equal outPaths in outJsrJsonContent, outHttpsJsonContent and outNpmJsonContent",
  );
}

function replacePlaceholder(
  f: FetcherFixture,
  domain: string,
): Omit<FetcherFixture, "inServerFS" | "outFetchedFilesFS"> {
  function doReplace(s: string): string {
    return s.replaceAll(PLACEHOLDER, domain);
  }

  return {
    inJsrJsonContent: doReplace(f.inJsrJsonContent),
    inNpmJsonContent: doReplace(f.inNpmJsonContent),
    inHttpsJsonContent: doReplace(f.inHttpsJsonContent),
    outJsrJsonContent: doReplace(f.outJsrJsonContent),
    outHttpsJsonContent: doReplace(f.outHttpsJsonContent),
    outNpmJsonContent: doReplace(f.outNpmJsonContent),
    outStdout: doReplace(f.outStdout || ""),
    outStderr: doReplace(f.outStderr || ""),
  };
}

function _fixtureFrom(f: FetcherFixture, serverConfig: ServerConfig): Fixture {
  const bin = Deno.args[0];
  if (!bin) {
    throw new Error("test expects cli args[0]: binary to execute");
  }

  const actualDomain = `http://${serverConfig.host}:${serverConfig.port}`;

  type VarNames = {
    commonLockJsrPath: null;
    commonLockNpmPath: null;
    commonLockHttpsPath: null;
    jsrRegistryUrl: null;
    outPathPrefix: null;
  }
  const vars: Vars<VarNames> = {
    commonLockJsrPath: {value:"./jsr.json",flag:"--common-lock-jsr-path"},
    commonLockNpmPath: {value:"./npm.json",flag:"--common-lock-npm-path"},
    commonLockHttpsPath: {value:"./https.json",flag:"--common-lock-https-path"},
    jsrRegistryUrl: {value:actualDomain,flag:"--jsr-registry-url"},
    outPathPrefix: {value:"./out",flag:"--out-path-prefix"},
  };

  checkOutFetchedFilesFs(f);

  const {
    inJsrJsonContent,
    inNpmJsonContent,
    inHttpsJsonContent,
    outJsrJsonContent,
    outHttpsJsonContent,
    outNpmJsonContent,
    outStdout,
    outStderr,
  } = replacePlaceholder(f, actualDomain);

  return {
    inputs: {
      args: [
        bin,
        vars.commonLockJsrPath.flag,
        vars.commonLockJsrPath.value,
        vars.commonLockNpmPath.flag,
        vars.commonLockNpmPath.value,
        vars.commonLockHttpsPath.flag,
        vars.commonLockHttpsPath.value,
        vars.jsrRegistryUrl.flag,
        vars.jsrRegistryUrl.value,
        vars.outPathPrefix.flag,
        vars.outPathPrefix.value,
      ],
      files: [
        {
          path: vars.commonLockJsrPath.value,
          isReal: false,
          content: inJsrJsonContent,
        },
        {
          path: vars.commonLockNpmPath.value,
          isReal: false,
          content: inNpmJsonContent,
        },
        {
          path: vars.commonLockHttpsPath.value,
          isReal: false,
          content: inHttpsJsonContent,
        },
        ...Object.entries(f.inServerFS).map(([path, content]) => ({
          path: `${serverConfig.root}/${path}`,
          isReal: false,
          content,
        })),
      ],
    },
    outputs: {
      files: {
        expected: [
          {
            path: `${vars.outPathPrefix.value}/jsr.json`,
            isReal: false,
            content: JSON.stringify(JSON.parse(outJsrJsonContent), null, 2),
          },
          {
            path: `${vars.outPathPrefix.value}/npm.json`,
            isReal: false,
            content: JSON.stringify(JSON.parse(outNpmJsonContent), null, 2),
          },
          {
            path: `${vars.outPathPrefix.value}/https.json`,
            isReal: false,
            content: JSON.stringify(
              JSON.parse(outHttpsJsonContent),
              null,
              2,
            ),
          },
          ...Object.entries(f.outFetchedFilesFS).map(([path, content]) => ({
            path: `${vars.outPathPrefix.value}/${path}`,
            isReal: false,
            content,
          })),
        ],
      },
      console: {
        expected: {
          stderr: outStderr || "",
        },
      },
    },
  };
}

const fetcherTests: Array<Test> = [
  {
    name: "empty",
    ...fixtureFrom({
      inJsrJsonContent: `[]`,
      inNpmJsonContent: `[]`,
      inHttpsJsonContent: `[]`,
      inServerFS: {},
      outJsrJsonContent: `[]`,
      outHttpsJsonContent: `[]`,
      outNpmJsonContent: `[]`,
      outFetchedFilesFS: {},
    }),
  },

  {
    name: "https_normal",
    ...fixtureFrom({
      inJsrJsonContent: `[]`,
      inNpmJsonContent: `[]`,
      inHttpsJsonContent: `[
{
  "url": "${PLACEHOLDER}/file1",
  "hash": {
    "string": "72ccb3d992389b04ac8d1a0b341d673b9ccd9c8b158e38541209cc1d7c65372e",
    "algorithm": "sha256",
    "encoding": "hex"
  },
  "meta": {
    "registry": "${PLACEHOLDER}"
  }
}
]`,
      inServerFS: { "file1": "file1_content" },
      outJsrJsonContent: `[]`,
      outHttpsJsonContent: `
[
  {
    "url": "${PLACEHOLDER}/file1",
    "hash": {
      "string": "72ccb3d992389b04ac8d1a0b341d673b9ccd9c8b158e38541209cc1d7c65372e",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "registry": "${PLACEHOLDER}"
    },
    "outPath": "aJ71c5fp_Oq5mI1LF6wBuBGlKg4NzKuOGytcD4AyoXM=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  }
]`,
      outNpmJsonContent: `[]`,
      outFetchedFilesFS: {
        "aJ71c5fp_Oq5mI1LF6wBuBGlKg4NzKuOGytcD4AyoXM=": "file1_content",
      },
    }),
  },

  {
    name: "https_original_url_override",
    ...fixtureFrom({
      inJsrJsonContent: `[]`,
      inNpmJsonContent: `[]`,
      inHttpsJsonContent: `[
{
  "url": "${PLACEHOLDER}/file2",
  "hash": {
    "string": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722",
    "algorithm": "sha256",
    "encoding": "hex"
  },
  "meta": {
    "registry": "${PLACEHOLDER}",
    "original_url": "original_url"
  }
}
]`,
      inServerFS: { "file2": "file2_content" },
      outJsrJsonContent: `[]`,
      outHttpsJsonContent: `
[
  {
    "url": "original_url",
    "hash": {
      "string": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "registry": "${PLACEHOLDER}",
      "original_url": "original_url"
    },
    "outPath": "v55BTm_wEitCZMJtQR2BhQurtNCyT9TwuZBTh5RLKTI=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  }
]`,
      outNpmJsonContent: `[]`,
      outFetchedFilesFS: {
        "v55BTm_wEitCZMJtQR2BhQurtNCyT9TwuZBTh5RLKTI=": "file2_content",
      },
    }),
  },

  {
    name: "npm_normal",
    ...fixtureFrom({
      inJsrJsonContent: `[]`,
      inNpmJsonContent: `[
  {
    "url": "${PLACEHOLDER}/file1",
    "hash": {
      "string": "JkkFrF7y7ChySIW5kkn6Jo7pa2V7Scn1SXka3ml2TipegmR8WCZ2MNvqfglYBa9O4KLpaLVjKXDds6NPgfdAkA==",
      "algorithm": "sha512",
      "encoding": "base64"
    },
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope1/package1@version1",
        "registry": "npm",
        "scope": "scope1",
        "name": "package1",
        "version": "version1",
        "suffix": null
      }
    }
  },
  {
    "url": "${PLACEHOLDER}/file2",
    "hash": {
      "string": "9mKBVgc2lyyiv340Ivq962tLb3ikY/gzIfmRhVnmK8yXxAMfTat0en0vuaxYKPhDbzuTT+owU7IghIkry8UMXg==",
      "algorithm": "sha512",
      "encoding": "base64"
    },
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope2/package2@version2",
        "registry": "npm",
        "scope": "scope2",
        "name": "package2",
        "version": "version2",
        "suffix": null
      }
    }
  }
      ]`,
      inHttpsJsonContent: `[]`,
      inServerFS: { "file1": "file1_content", "file2": "file2_content" },
      outJsrJsonContent: `[]`,
      outHttpsJsonContent: `[]`,
      outNpmJsonContent: `
[
  {
    "url": "${PLACEHOLDER}/file1",
    "hash": {
      "string": "JkkFrF7y7ChySIW5kkn6Jo7pa2V7Scn1SXka3ml2TipegmR8WCZ2MNvqfglYBa9O4KLpaLVjKXDds6NPgfdAkA==",
      "algorithm": "sha512",
      "encoding": "base64"
    },
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope1/package1@version1",
        "registry": "npm",
        "scope": "scope1",
        "name": "package1",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "aJ71c5fp_Oq5mI1LF6wBuBGlKg4NzKuOGytcD4AyoXM=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/file2",
    "hash": {
      "string": "9mKBVgc2lyyiv340Ivq962tLb3ikY/gzIfmRhVnmK8yXxAMfTat0en0vuaxYKPhDbzuTT+owU7IghIkry8UMXg==",
      "algorithm": "sha512",
      "encoding": "base64"
    },
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope2/package2@version2",
        "registry": "npm",
        "scope": "scope2",
        "name": "package2",
        "version": "version2",
        "suffix": null
      }
    },
    "outPath": "v55BTm_wEitCZMJtQR2BhQurtNCyT9TwuZBTh5RLKTI=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "@scope1/package1/registry.json",
    "hash": {
      "string": "",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "outPath": "HJfXafivJOS+C7ZOGAXXpmYtUa86mstKBwPeYkjunEE=",
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope1/package1@version1",
        "registry": "npm",
        "scope": "scope1",
        "name": "package1",
        "version": "version1",
        "suffix": null
      }
    }
  },
  {
    "url": "@scope2/package2/registry.json",
    "hash": {
      "string": "",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "outPath": "zJgDfa3MO3f2+wwqhxdbP130NF+Yb52EaaLJTbCQhjY=",
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope2/package2@version2",
        "registry": "npm",
        "scope": "scope2",
        "name": "package2",
        "version": "version2",
        "suffix": null
      }
    }
  }
]
      `,
      outFetchedFilesFS: {
        "aJ71c5fp_Oq5mI1LF6wBuBGlKg4NzKuOGytcD4AyoXM=": "file1_content",
        "v55BTm_wEitCZMJtQR2BhQurtNCyT9TwuZBTh5RLKTI=": "file2_content",
        "HJfXafivJOS+C7ZOGAXXpmYtUa86mstKBwPeYkjunEE=": `{
  "name": "package1",
  "dist-tags": {},
  "_deno.etag": "",
  "versions": {
    "version1": {
      "version": "version1",
      "dist": {
        "tarball": ""
      },
      "bin": {}
    }
  }
}`,
        "zJgDfa3MO3f2+wwqhxdbP130NF+Yb52EaaLJTbCQhjY=": `{
  "name": "package2",
  "dist-tags": {},
  "_deno.etag": "",
  "versions": {
    "version2": {
      "version": "version2",
      "dist": {
        "tarball": ""
      },
      "bin": {}
    }
  }
}`,
      },
    }),
  },

  {
    name: "npm_same_name_different_version",
    ...fixtureFrom({
      inJsrJsonContent: `[]`,
      inNpmJsonContent: `[
  {
    "url": "${PLACEHOLDER}/file1",
    "hash": {
      "string": "JkkFrF7y7ChySIW5kkn6Jo7pa2V7Scn1SXka3ml2TipegmR8WCZ2MNvqfglYBa9O4KLpaLVjKXDds6NPgfdAkA==",
      "algorithm": "sha512",
      "encoding": "base64"
    },
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope1/package1@version1",
        "registry": "npm",
        "scope": "scope1",
        "name": "package1",
        "version": "version1",
        "suffix": null
      }
    }
  },
  {
    "url": "${PLACEHOLDER}/file2",
    "hash": {
      "string": "9mKBVgc2lyyiv340Ivq962tLb3ikY/gzIfmRhVnmK8yXxAMfTat0en0vuaxYKPhDbzuTT+owU7IghIkry8UMXg==",
      "algorithm": "sha512",
      "encoding": "base64"
    },
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope1/package1@version2",
        "registry": "npm",
        "scope": "scope1",
        "name": "package1",
        "version": "version2",
        "suffix": null
      }
    }
  }
      ]`,
      inHttpsJsonContent: `[]`,
      inServerFS: { "file1": "file1_content", "file2": "file2_content" },
      outJsrJsonContent: `[]`,
      outHttpsJsonContent: `[]`,
      outNpmJsonContent: `
[
  {
    "url": "${PLACEHOLDER}/file1",
    "hash": {
      "string": "JkkFrF7y7ChySIW5kkn6Jo7pa2V7Scn1SXka3ml2TipegmR8WCZ2MNvqfglYBa9O4KLpaLVjKXDds6NPgfdAkA==",
      "algorithm": "sha512",
      "encoding": "base64"
    },
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope1/package1@version1",
        "registry": "npm",
        "scope": "scope1",
        "name": "package1",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "aJ71c5fp_Oq5mI1LF6wBuBGlKg4NzKuOGytcD4AyoXM=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/file2",
    "hash": {
      "string": "9mKBVgc2lyyiv340Ivq962tLb3ikY/gzIfmRhVnmK8yXxAMfTat0en0vuaxYKPhDbzuTT+owU7IghIkry8UMXg==",
      "algorithm": "sha512",
      "encoding": "base64"
    },
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope1/package1@version2",
        "registry": "npm",
        "scope": "scope1",
        "name": "package1",
        "version": "version2",
        "suffix": null
      }
    },
    "outPath": "v55BTm_wEitCZMJtQR2BhQurtNCyT9TwuZBTh5RLKTI=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "@scope1/package1/registry.json",
    "hash": {
      "string": "",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "outPath": "HJfXafivJOS+C7ZOGAXXpmYtUa86mstKBwPeYkjunEE=",
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope1/package1@version1",
        "registry": "npm",
        "scope": "scope1",
        "name": "package1",
        "version": "version1",
        "suffix": null
      },
      "otherPackageSpecifiers": [
        {
          "fullString": "@scope1/package1@version2",
          "registry": "npm",
          "scope": "scope1",
          "name": "package1",
          "version": "version2",
          "suffix": null
        }
      ]
    }
  }
]`,
      outFetchedFilesFS: {
        "aJ71c5fp_Oq5mI1LF6wBuBGlKg4NzKuOGytcD4AyoXM=": "file1_content",
        "v55BTm_wEitCZMJtQR2BhQurtNCyT9TwuZBTh5RLKTI=": "file2_content",
        "HJfXafivJOS+C7ZOGAXXpmYtUa86mstKBwPeYkjunEE=": `{
  "name": "package1",
  "dist-tags": {},
  "_deno.etag": "",
  "versions": {
    "version1": {
      "version": "version1",
      "dist": {
        "tarball": ""
      },
      "bin": {}
    },
    "version2": {
      "version": "version2",
      "dist": {
        "tarball": ""
      },
      "bin": {}
    }
  }
}`,
      },
    }),
  },

  {
    name: "jsr_normal",
    ...fixtureFrom({
      inJsrJsonContent: `[
  {
    "url": "${PLACEHOLDER}/@scope/package/version1_meta.json",
    "hash": {
      "string": "7463bfae478fd913b87543c65ba4948bc8f66684b3bb1a68b8fe3eb26be37941",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    }
  }
]`,
      inNpmJsonContent: `[]`,
      inHttpsJsonContent: `[]`,
      inServerFS: {
        "@scope/package/version1_meta.json": `{
  "manifest": {
    "/file2": { "size": 1, "checksum": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722" }
  },
  "moduleGraph1": {
    "/file2": {}
  },
  "exports": {
    ".": "./file2"
  }
}`,
        "@scope/package/version1/file2": "file2_content",
      },
      outJsrJsonContent: `
[
  {
    "url": "${PLACEHOLDER}/@scope/package/version1_meta.json",
    "hash": {
      "string": "7463bfae478fd913b87543c65ba4948bc8f66684b3bb1a68b8fe3eb26be37941",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "p9wCwr_piQ1Pg8bTBrhWua5JHdpQJZtcQKdMDG1F+Sc=",
    "headers": {
      "content-type": "application/json"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version1/file2",
    "hash": {
      "string": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "ZS2orl8MomYoRTcvFcGUK8cR3iQqWPpFbe3X2n5JIJQ=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/meta.json",
    "hash": {
      "string": "",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "outPath": "ZW_ALaNedyI3BN82yJBBmegi3i8hAtAwi2upi6efSPw=",
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    }
  }
]`,
      outHttpsJsonContent: `[]`,
      outNpmJsonContent: `[]`,
      outFetchedFilesFS: {
        "ZS2orl8MomYoRTcvFcGUK8cR3iQqWPpFbe3X2n5JIJQ=": "file2_content",
        "ZW_ALaNedyI3BN82yJBBmegi3i8hAtAwi2upi6efSPw=": `{
  "name": "package",
  "scope": "scope",
  "latest": "version1",
  "versions": {
    "version1": {}
  }
}`,
        "p9wCwr_piQ1Pg8bTBrhWua5JHdpQJZtcQKdMDG1F+Sc=": `{
  "manifest": {
    "/file2": { "size": 1, "checksum": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722" }
  },
  "moduleGraph1": {
    "/file2": {}
  },
  "exports": {
    ".": "./file2"
  }
}`,
      },
    }),
  },

  {
    name: "jsr_same_name_different_version",
    ...fixtureFrom({
      inJsrJsonContent: `[
  {
    "url": "${PLACEHOLDER}/@scope/package/version1_meta.json",
    "hash": {
      "string": "73dc853b1e4289c5aa743a462ca493aa052148ff722c853250c5d72a767f407c",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version2_meta.json",
    "hash": {
      "string": "7463bfae478fd913b87543c65ba4948bc8f66684b3bb1a68b8fe3eb26be37941",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version2",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version2",
        "suffix": null
      }
    }
  }
]`,
      inNpmJsonContent: `[]`,
      inHttpsJsonContent: `[]`,
      inServerFS: {
        "@scope/package/version1_meta.json": `{
  "manifest": {
    "/file1": { "size": 1, "checksum": "72ccb3d992389b04ac8d1a0b341d673b9ccd9c8b158e38541209cc1d7c65372e" }
  },
  "moduleGraph1": {
    "/file1": {}
  },
  "exports": {
    ".": "./file1"
  }
}`,
        "@scope/package/version2_meta.json": `{
  "manifest": {
    "/file2": { "size": 1, "checksum": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722" }
  },
  "moduleGraph1": {
    "/file2": {}
  },
  "exports": {
    ".": "./file2"
  }
}`,
        "@scope/package/version1/file1": "file1_content",
        "@scope/package/version2/file2": "file2_content",
      },
      outJsrJsonContent: `
[
  {
    "url": "${PLACEHOLDER}/@scope/package/version1_meta.json",
    "hash": {
      "string": "73dc853b1e4289c5aa743a462ca493aa052148ff722c853250c5d72a767f407c",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "p9wCwr_piQ1Pg8bTBrhWua5JHdpQJZtcQKdMDG1F+Sc=",
    "headers": {
      "content-type": "application/json"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version1/file1",
    "hash": {
      "string": "72ccb3d992389b04ac8d1a0b341d673b9ccd9c8b158e38541209cc1d7c65372e",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "e0_ikqYUmXwwhLQX9Knb8udGb06OtTa2aj70CfVldR0=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version2_meta.json",
    "hash": {
      "string": "7463bfae478fd913b87543c65ba4948bc8f66684b3bb1a68b8fe3eb26be37941",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version2",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version2",
        "suffix": null
      }
    },
    "outPath": "KQ5N5yM__YJBNzLFQdW_5QAD0gjbxac+y2HoBs6o0Ng=",
    "headers": {
      "content-type": "application/json"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version2/file2",
    "hash": {
      "string": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "packageSpecifier": {
        "fullString": "@scope/package@version2",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version2",
        "suffix": null
      }
    },
    "outPath": "j0KcQTwaVwucALJk02QJBawei0tpH4IPEPjaKt37g+o=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/meta.json",
    "hash": {
      "string": "",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "outPath": "ZW_ALaNedyI3BN82yJBBmegi3i8hAtAwi2upi6efSPw=",
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      },
      "otherPackageSpecifiers": [
        {
          "fullString": "@scope/package@version2",
          "registry": "jsr",
          "scope": "scope",
          "name": "package",
          "version": "version2",
          "suffix": null
        }
      ]
    }
  }
]`,
      outHttpsJsonContent: `[]`,
      outNpmJsonContent: `[]`,
      outFetchedFilesFS: {
        "KQ5N5yM__YJBNzLFQdW_5QAD0gjbxac+y2HoBs6o0Ng=": `{
  "manifest": {
    "/file2": { "size": 1, "checksum": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722" }
  },
  "moduleGraph1": {
    "/file2": {}
  },
  "exports": {
    ".": "./file2"
  }
}`,
        "ZW_ALaNedyI3BN82yJBBmegi3i8hAtAwi2upi6efSPw=": `{
  "name": "package",
  "scope": "scope",
  "latest": "version1",
  "versions": {
    "version1": {},
    "version2": {}
  }
}`,
        "e0_ikqYUmXwwhLQX9Knb8udGb06OtTa2aj70CfVldR0=": `file1_content`,
        "j0KcQTwaVwucALJk02QJBawei0tpH4IPEPjaKt37g+o=": `file2_content`,
        "p9wCwr_piQ1Pg8bTBrhWua5JHdpQJZtcQKdMDG1F+Sc=": `{
  "manifest": {
    "/file1": { "size": 1, "checksum": "72ccb3d992389b04ac8d1a0b341d673b9ccd9c8b158e38541209cc1d7c65372e" }
  },
  "moduleGraph1": {
    "/file1": {}
  },
  "exports": {
    ".": "./file1"
  }
}`,
      },
    }),
  },

  {
    name: "jsr_module_graphs",
    ...fixtureFrom({
      inJsrJsonContent: `[
  {
    "url": "${PLACEHOLDER}/@scope/package/version1_meta.json",
    "hash": {
      "string": "ca6f1cf6cba30b9d0bc6a6d118c4b769e4a380aeeaef18117125ccfaec8c91c2",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    }
  }
]`,
      inNpmJsonContent: `[]`,
      inHttpsJsonContent: `[]`,
      inServerFS: {
        "@scope/package/version1_meta.json": `{
  "manifest": {
    "/file1": { "size": 1, "checksum": "72ccb3d992389b04ac8d1a0b341d673b9ccd9c8b158e38541209cc1d7c65372e" },
    "/file2": { "size": 1, "checksum": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722" },
    "/file3": { "size": 1, "checksum": "7acada80e8c3caff3753cffe872dd6308c70dcbccb81b4dd22c3e7c4d0dda085" },
    "/file4": { "size": 1, "checksum": "ef994240619c32739ccdbac1e46c648310ef82ccefb4ebc6efeefb64f4906722" },
    "/dir1/file1_1": { "size": 1, "checksum": "70da57b4041e8e52a0ca0984f83a8017a4dc8bcd29dfefa695d731a22e9f7146" },
    "/dir1/dir2/file2_1": { "size": 1, "checksum": "823a1df28cb774b767de69a2b73bcfa28e4c3ce40791b3ca51e11515aa42a526" }
  },
  "moduleGraph2": {
    "/file1": {
      "dependencies": [
        {
          "type": "static",
          "specifier": "./file2"
        },
        {
          "type": "dynamic",
          "argument": "./file3"
        },
        {
          "type": "dynamic",
          "argument": "npm:this_should_be_skipped@version"
        }
      ]
    },
    "/dir1/file1_1": {
      "dependencies": [
        {
          "type": "static",
          "specifier": "./dir2/file2_1"
        },
        {
          "type": "static",
          "specifier": "../file1"
        }
      ]
    }
  },
  "exports": {
    ".": "./file1",
    "./file10": "./file4"
  }
}`,
        "@scope/package/version1/file1": "file1_content",
        "@scope/package/version1/file2": "file2_content",
        "@scope/package/version1/file3": "file3_content",
        "@scope/package/version1/file4": "file4_content",
        "@scope/package/version1/dir1/file1_1": "file1_1_content",
        "@scope/package/version1/dir1/dir2/file2_1": "file2_1_content",
      },
      outJsrJsonContent: `[
  {
    "url": "${PLACEHOLDER}/@scope/package/version1_meta.json",
    "hash": {
      "string": "ca6f1cf6cba30b9d0bc6a6d118c4b769e4a380aeeaef18117125ccfaec8c91c2",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "p9wCwr_piQ1Pg8bTBrhWua5JHdpQJZtcQKdMDG1F+Sc=",
    "headers": {
      "content-type": "application/json"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version1/file1",
    "hash": {
      "string": "72ccb3d992389b04ac8d1a0b341d673b9ccd9c8b158e38541209cc1d7c65372e",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "e0_ikqYUmXwwhLQX9Knb8udGb06OtTa2aj70CfVldR0=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version1/dir1/file1_1",
    "hash": {
      "string": "70da57b4041e8e52a0ca0984f83a8017a4dc8bcd29dfefa695d731a22e9f7146",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "0wgrfnzfenzwHYPAwZSBVqh0rq3XRzDS4g96uMfmYAM=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version1/file4",
    "hash": {
      "string": "ef994240619c32739ccdbac1e46c648310ef82ccefb4ebc6efeefb64f4906722",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "cmcw_vUVuY6L_EF2yyTjJoxH4L8R8LJNnRUccBbwkKg=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version1/file2",
    "hash": {
      "string": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "ZS2orl8MomYoRTcvFcGUK8cR3iQqWPpFbe3X2n5JIJQ=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version1/file3",
    "hash": {
      "string": "7acada80e8c3caff3753cffe872dd6308c70dcbccb81b4dd22c3e7c4d0dda085",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "JE2zACDz1Is1AFnxriQq+SXIDOoxb34Ri97EnWECfR8=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/version1/dir1/dir2/file2_1",
    "hash": {
      "string": "823a1df28cb774b767de69a2b73bcfa28e4c3ce40791b3ca51e11515aa42a526",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "meta": {
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "umK2ZgwajOgbColbdZe8DkUwB1GO0xT6DemFRluvwD0=",
    "headers": {
      "content-type": "application/octet-stream"
    }
  },
  {
    "url": "${PLACEHOLDER}/@scope/package/meta.json",
    "hash": {
      "string": "",
      "algorithm": "sha256",
      "encoding": "hex"
    },
    "outPath": "ZW_ALaNedyI3BN82yJBBmegi3i8hAtAwi2upi6efSPw=",
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    }
  }
]`,
      outHttpsJsonContent: `[]`,
      outNpmJsonContent: `[]`,
      outFetchedFilesFS: {
        "e0_ikqYUmXwwhLQX9Knb8udGb06OtTa2aj70CfVldR0=": `file1_content`,
        "ZS2orl8MomYoRTcvFcGUK8cR3iQqWPpFbe3X2n5JIJQ=": `file2_content`,
        "JE2zACDz1Is1AFnxriQq+SXIDOoxb34Ri97EnWECfR8=": `file3_content`,
        "cmcw_vUVuY6L_EF2yyTjJoxH4L8R8LJNnRUccBbwkKg=": `file4_content`,
        "0wgrfnzfenzwHYPAwZSBVqh0rq3XRzDS4g96uMfmYAM=": `file1_1_content`,
        "umK2ZgwajOgbColbdZe8DkUwB1GO0xT6DemFRluvwD0=": `file2_1_content`,
        "p9wCwr_piQ1Pg8bTBrhWua5JHdpQJZtcQKdMDG1F+Sc=": `{
  "manifest": {
    "/file1": { "size": 1, "checksum": "72ccb3d992389b04ac8d1a0b341d673b9ccd9c8b158e38541209cc1d7c65372e" },
    "/file2": { "size": 1, "checksum": "16c4c6c767910c2eca896281f1d56f2b62fc42b073004b469a2c1d8e4f9e5722" },
    "/file3": { "size": 1, "checksum": "7acada80e8c3caff3753cffe872dd6308c70dcbccb81b4dd22c3e7c4d0dda085" },
    "/file4": { "size": 1, "checksum": "ef994240619c32739ccdbac1e46c648310ef82ccefb4ebc6efeefb64f4906722" },
    "/dir1/file1_1": { "size": 1, "checksum": "70da57b4041e8e52a0ca0984f83a8017a4dc8bcd29dfefa695d731a22e9f7146" },
    "/dir1/dir2/file2_1": { "size": 1, "checksum": "823a1df28cb774b767de69a2b73bcfa28e4c3ce40791b3ca51e11515aa42a526" }
  },
  "moduleGraph2": {
    "/file1": {
      "dependencies": [
        {
          "type": "static",
          "specifier": "./file2"
        },
        {
          "type": "dynamic",
          "argument": "./file3"
        },
        {
          "type": "dynamic",
          "argument": "npm:this_should_be_skipped@version"
        }
      ]
    },
    "/dir1/file1_1": {
      "dependencies": [
        {
          "type": "static",
          "specifier": "./dir2/file2_1"
        },
        {
          "type": "static",
          "specifier": "../file1"
        }
      ]
    }
  },
  "exports": {
    ".": "./file1",
    "./file10": "./file4"
  }
}`,
        "ZW_ALaNedyI3BN82yJBBmegi3i8hAtAwi2upi6efSPw=": `{
  "name": "package",
  "scope": "scope",
  "latest": "version1",
  "versions": {
    "version1": {}
  }
}`,
      },
    }),
  },
];

runTests(fetcherTests);
