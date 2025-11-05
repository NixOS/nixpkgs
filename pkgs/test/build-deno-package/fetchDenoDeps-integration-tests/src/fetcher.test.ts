import { argsToCommand, assertEq, dec, runTests } from "./utils.ts";
import { Fixture, SetupFn, Test, Vars, VirtualFS } from "./types.d.ts";

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

function fixtureFrom(f: FetcherFixture): { fixture: Fixture; preFn: SetupFn } {
  return {
    fixture: _fixtureFrom(f, serverConfig),
    preFn: startMockServer(serverConfig),
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
    "outFetchedFilesFS specified in fixture, do not equal outPaths in outVendoredJsonContent and outNpmJsonContent",
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

  const vars: Vars = {
    "common-lock-jsr-path": "./jsr.json",
    "common-lock-npm-path": "./npm.json",
    "common-lock-https-path": "./https.json",
    "in-jsr-registry-url": actualDomain,
    "out-path-prefix": "./out",
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
        "--common-lock-jsr-path",
        vars["common-lock-jsr-path"],
        "--common-lock-https-path",
        vars["common-lock-https-path"],
        "--common-lock-npm-path",
        vars["common-lock-npm-path"],
        "--jsr-registry-url",
        vars["jsr-registry-url"],
        "--out-path-prefix",
        vars["out-path-prefix"],
      ],
      files: [
        {
          path: vars["common-lock-jsr-path"],
          isReal: false,
          content: inJsrJsonContent,
        },
        {
          path: vars["common-lock-npm-path"],
          isReal: false,
          content: inNpmJsonContent,
        },
        {
          path: vars["common-lock-https-path"],
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
            path: `${vars["out-path-prefix"]}/jsr.json`,
            isReal: false,
            content: JSON.stringify(JSON.parse(outJsrJsonContent), null, 2),
          },
          {
            path: `${vars["out-path-prefix"]}/npm.json`,
            isReal: false,
            content: JSON.stringify(JSON.parse(outNpmJsonContent), null, 2),
          },
          {
            path: `${vars["out-path-prefix"]}/https.json`,
            isReal: false,
            content: JSON.stringify(
              JSON.parse(outHttpsJsonContent),
              null,
              2,
            ),
          },
          ...Object.entries(f.outFetchedFilesFS).map(([path, content]) => ({
            path: `${vars["out-path-prefix"]}/${path}`,
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

const lockfileTransformerTests: Array<Test> = [
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
  "hash": "hash1",
  "hashAlgo": "sha256",
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
    "hash": "hash1",
    "hashAlgo": "sha256",
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
  "hash": "hash2",
  "hashAlgo": "sha256",
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
    "hash": "hash2",
    "hashAlgo": "sha256",
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
    "hash": "hash1",
    "hashAlgo": "sha512",
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
    "hash": "hash2",
    "hashAlgo": "sha512",
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
    "hash": "hash1",
    "hashAlgo": "sha512",
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
    "hash": "hash2",
    "hashAlgo": "sha512",
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
    "hash": "",
    "hashAlgo": "sha256",
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
    "hash": "",
    "hashAlgo": "sha256",
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
    "hash": "hash1",
    "hashAlgo": "sha512",
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
    "hash": "hash2",
    "hashAlgo": "sha512",
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
    "hash": "hash1",
    "hashAlgo": "sha512",
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
    "hash": "hash2",
    "hashAlgo": "sha512",
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
    "hash": "",
    "hashAlgo": "sha256",
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
    "hash": "hash1",
    "hashAlgo": "sha256",
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
    "/file2": { "size": 1, "checksum": "hash2" }
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
    "hash": "hash1",
    "hashAlgo": "sha256",
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
    "hash": "hash2",
    "hashAlgo": "sha256",
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
    "hash": "",
    "hashAlgo": "sha256",
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
    "/file2": { "size": 1, "checksum": "hash2" }
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
    "hash": "hash1",
    "hashAlgo": "sha256",
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
    "hash": "hash2",
    "hashAlgo": "sha256",
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
    "/file1": { "size": 1, "checksum": "hash2" }
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
    "/file2": { "size": 1, "checksum": "hash2" }
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
    "hash": "hash1",
    "hashAlgo": "sha256",
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
    "hash": "hash2",
    "hashAlgo": "sha256",
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
    "hash": "hash2",
    "hashAlgo": "sha256",
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
    "hash": "hash2",
    "hashAlgo": "sha256",
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
    "hash": "",
    "hashAlgo": "sha256",
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
    "/file2": { "size": 1, "checksum": "hash2" }
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
    "/file1": { "size": 1, "checksum": "hash2" }
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
    "hash": "hash1",
    "hashAlgo": "sha256",
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
    "/file1": { "size": 1, "checksum": "hash1" },
    "/file2": { "size": 1, "checksum": "hash2" },
    "/file3": { "size": 1, "checksum": "hash3" },
    "/file4": { "size": 1, "checksum": "hash4" },
    "/dir1/file1_1": { "size": 1, "checksum": "hash1_1" },
    "/dir1/dir2/file2_1": { "size": 1, "checksum": "hash2_1" }
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
    "hash": "hash1",
    "hashAlgo": "sha256",
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
    "hash": "hash1",
    "hashAlgo": "sha256",
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
    "hash": "hash1_1",
    "hashAlgo": "sha256",
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
    "hash": "hash4",
    "hashAlgo": "sha256",
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
    "hash": "hash2",
    "hashAlgo": "sha256",
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
    "hash": "hash3",
    "hashAlgo": "sha256",
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
    "hash": "hash2_1",
    "hashAlgo": "sha256",
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
    "hash": "",
    "hashAlgo": "sha256",
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
    "/file1": { "size": 1, "checksum": "hash1" },
    "/file2": { "size": 1, "checksum": "hash2" },
    "/file3": { "size": 1, "checksum": "hash3" },
    "/file4": { "size": 1, "checksum": "hash4" },
    "/dir1/file1_1": { "size": 1, "checksum": "hash1_1" },
    "/dir1/dir2/file2_1": { "size": 1, "checksum": "hash2_1" }
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

runTests(lockfileTransformerTests);
