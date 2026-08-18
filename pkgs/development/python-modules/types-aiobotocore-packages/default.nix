{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage (finalAttrs: {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName finalAttrs.oldStylePackages then
            "types-aiobotocore-${serviceName}"
          else
            "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        boto3
        botocore
      ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    });
in
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "3.8.0"
      "sha256-TV/lWv8KMkb0PV34/8ZqbrrFFtlonAJnuh8AuLP3TUk=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "3.8.0"
      "sha256-6KonHXkKVD9Hhwx1pfFzQ0ggtBnxajQqcIsKocnA13k=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "3.8.0"
      "sha256-bk4YJ7KUJZjOe/WPxQbTr/QwcJ3sQxqvn+MHvAGxiyQ=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "3.8.0"
      "sha256-MQ0QMD3+FPIRpB/AoakZ7TOuhnrkN74WS2gNN8SiIxw=";

  types-aiobotocore-aiops =
    buildTypesAiobotocorePackage "aiops" "3.8.0"
      "sha256-xQ6WWOfQGzD9N3yz+wJX6AD2bNTnFQbAt4aJeVVJxxs=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "3.8.0"
      "sha256-oT0eyLJ3yVoZEEhlyJSSgocr5qM4ii6vUTIqzIk7V4w=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "3.8.0"
      "sha256-ht3vfEic/yZlxJ+TEFdSp5sk6KQ8MwcvQ46jwLxujSc=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "3.8.0"
      "sha256-ty6vtESwxpWfGEAh/NcaHW2Al/2rf7bH2iJVLbBuF7Y=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "3.8.0"
      "sha256-f4Aull1pQhJueRWImvPSLfrisERpV7GP0Wbg7v7UDFA=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "3.8.0"
      "sha256-0SbZx9Y1w1z2lDuFn77435t57NSqZOBbH0bvYPLKN4o=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "3.8.0"
      "sha256-d3k//FfTL7CEtk/QHf+Nsy3tvLMfGnYkbIbA0S9CrjU=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "3.8.0"
      "sha256-KmnUcsKSAh+HJ9PQbbD7ufGkE6TDE2gx62JEUNMQvaE=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "3.8.0"
      "sha256-6nbInwY4CWKyD2U8U0TM4xh3as9DUh+wQXE1BztABuI=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "3.8.0"
      "sha256-sU2IrkdaI8YnCqMAacTBVSiuEfpJ+gGlHbyng3Zyj1w=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "3.8.0"
      "sha256-T1mhUU7YUeFAIMKNq7uSFTXmUWqRgucTOHmw4qyqPP4=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "3.8.0"
      "sha256-+3vCZ3lc/CKoswelcu5H8nPTAiCN6D4vm0b3JCx86Pc=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "3.8.0"
      "sha256-vrkzCZHq1Fkuh98xek7ARK3mSzcUKtPlmvyqRI+X0wM=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "3.8.0"
      "sha256-dlRWwUGP0EE36e8hMyLnXkNUIzWiZYeUGvBYxDU737E=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "3.8.0"
      "sha256-0FvVEbyV1pIdDJHdgtSozEGakX0rjYGV5yQXxJVVkbk=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "3.8.0"
      "sha256-6I6fPYnKf5sN7Of8bNNj46tuM2XCQ2qibtZ6qV6cmsU=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "3.8.0"
      "sha256-ZuSgLKSPpe6kJV30NYTF7Q4KyZ2Knqk1U+ipckeeUY0=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "3.8.0"
      "sha256-Wvc2NQN6VNQpM8n/R00bD6Ajb1p7uRijkb/adOtA4sk=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "3.8.0"
      "sha256-wLk87oe/TTowmJyrUA1FcGt7bDqljetWS8o5olTNeH8=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "3.8.0"
      "sha256-ms4j+7e+wW2NggTdD4uWXifrMU/KSUqHBHTuyS8WIvU=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "3.8.0"
      "sha256-xvm9klK5RODs7943i6PLzCiqBV6JUxEUno20Ne4Ka8I=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "3.8.0"
      "sha256-xwYs8cbHp6l5gHsdX0g1XKc9WUWSPFGGnGWU1LslFcA=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "3.8.0"
      "sha256-Q++4MqRw3IVYWy7Mn0ciDAY4ZGxkyGU2ZAgaNIFOO0A=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "3.8.0"
      "sha256-BomjS9wFU73VAoP3IeFbxzWiDmgp7lLD+th6emvohtY=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "3.8.0"
      "sha256-KB1ABluHwEMoyogjUSgA1+hOc+TijqtCPEZsegMPx0w=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "3.8.0"
      "sha256-1QJosVGi8DMj6wZhCJoKLw01RuSZs5ei8SMtKAzbPC4=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "3.8.0"
      "sha256-bUoHpi6tpHf56CjiXjFSvsv5EzHAhOoApYyOfCLJHE0=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "3.8.0"
      "sha256-WIOGg5MevoWNkJCUYXST217IHsYL/Pl6yfsaFgWu2U8=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "3.8.0"
      "sha256-55414gq0mGUE9iRFRFEJLK+eWwhCnFEJP50AFU7RlLI=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "3.8.0"
      "sha256-QDqbERJfGYoU5IAKYkDaLtxLIK0bPfkH+m4C84VIZPs=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "3.8.0"
      "sha256-Bl88eeCxZ7ppR+zeiwsstENGs9EvP+NMCf51CWQk+Fc=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "3.8.0"
      "sha256-IHr+2Z/QfkwkjJkBVbbauPud6r2Vh3fZV12+yBhhAiQ=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "3.8.0"
      "sha256-EZMD+N22H0BNTS4hFy1h3jp7CEveu8dqliC+nJIlGkA=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "3.8.0"
      "sha256-vCLNrVVES+Q290eh7lYMShAb7P/mVSJr1u9Iv02L3TU=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "3.8.0"
      "sha256-7bIcEkmL4vlCR2FlGWF74xC9QC5W6hOU36QyYFt1Ay0=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "3.8.0"
      "sha256-SAG0UTB0Vsx9v/rfg0CzwY/PBrTWXHgorlIZDrcZIIg=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "3.8.0"
      "sha256-jflp7G++NfpgUsULhaS8nRG6rz8JF+l3+cSwmYRcEhM=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "3.8.0"
      "sha256-Ebq4NjQ3pAJc9xdDQNMjUwHez4SuisLWWZXfeAFCTyU=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "3.8.0"
      "sha256-5fdOt2izef0LJYiPvbvJrN2SmS1k8vz87V7IH2OvmXE=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "3.8.0"
      "sha256-xre7G6hOnqfvrG2ZxggHnyiSL6gbBx+j1BUhbopi160=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "3.8.0"
      "sha256-dPFa5NRBNfhAvzLz3wBqUS8qyLarecgC5hw0hNcKQSI=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "3.8.0"
      "sha256-mKB9nl9YNfgM4JmN3JNk3cOcEEiCeE3WjtV/eIzL/S8=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "3.8.0"
      "sha256-0gmnQvuDAJfF6kZKBnGUJoRQYReIyeGbwE8I9iAHAAA=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "3.8.0"
      "sha256-dKXo5YgiNDFY+188dmP0Fa4L1UvjvIxSSDg9HTUaNJI=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "3.8.0"
      "sha256-wt/FFwZN+oM6TrW05C8eyWeA8JyzFIItFDFK04q3wi4=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "3.8.0"
      "sha256-+tCUQO9vLV+bj+Sr+A1aQ3YaJXJA2DGSmRmYLwfAVVk=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "3.8.0"
      "sha256-2/ECOe2Ksk+pQyxhRYFOnlRmVsO6EHn6DV5qNOZ+aVg=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "3.8.0"
      "sha256-LBPyalrIgcE20yhMgteps29AbIwudI8MxBGw8NMHvas=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "3.8.0"
      "sha256-hUcBOamdbpqV8F8Ff5NAJHJJa0M2axmaT2KWqc+QsRQ=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "3.8.0"
      "sha256-IADjU2gsNoAcGmzuvCX4+NF5kdZZHqIKdHDvrPCXh0I=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "3.8.0"
      "sha256-ehZf6MlVBw+kxCenP/Om744Rw4mm+onJMXzzoAtvhdI=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "3.8.0"
      "sha256-yb/nSWrkXEXhLLRj4bCmeiQb8l5qwrwqUIFu7LP/eWk=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "3.8.0"
      "sha256-mN4CzC6FFyYC+p+ao1LAHw5F7jCf8RbCj3KRsKUfmw8=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "3.8.0"
      "sha256-hLFSk6fLTBLrhegnnCBhzivcwqQ9RhVZzHRhKfjjVr8=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "3.8.0"
      "sha256-i11jMMPBQkN45mJLxh72PGuMmb3OtBjQQ0ewuCGNE+k=";

  types-aiobotocore-codeconnections =
    buildTypesAiobotocorePackage "codeconnections" "3.8.0"
      "sha256-TsSV0LPUU6woke73Sj0syPUzb/BzyVzzZnaXGm4rZjc=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "3.8.0"
      "sha256-MLmdTSCswWneBm0MH7qvDIqYhEoOq8IT2NFNca4nji8=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "3.8.0"
      "sha256-YYbOiHkzKeN9UMPpE/83zJem4oNltxtPKdigQ6VVxiM=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "3.8.0"
      "sha256-0hTfNChzO9uJZKHlZ6gEjM4E7aoD+mG+6m8Lq1rQfJo=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "3.8.0"
      "sha256-FBHhzMtZ12yx1ncyI5LePJ07IBvYK2EZ0Yy+b2o/qK8=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "3.8.0"
      "sha256-Ws1GWO4i2DuA8R26NjYsnPytmlxWRtWbYu66UfkC6rI=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "3.8.0"
      "sha256-htS73FiaAdVaUwwTwHDw0f9VXkR7FlSw8fZq484hxjs=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "3.8.0"
      "sha256-ELWOrPX9l7ivbqX64iNbxu4iKd1NQi3NTq7iNPj4dbA=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "3.8.0"
      "sha256-i0+EValBs1vLL8GJ0S959upzqXK82oMNHbzmfAjXtY0=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "3.8.0"
      "sha256-8vSK/0AKwTWW4NsRj22SGt8Lgc5F8vJ9QsDEem37l2M=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "3.8.0"
      "sha256-D+FwTGi4LxKj1L794Hx/JLyMQrTMjjcff5okupsCwto=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "3.8.0"
      "sha256-sbG/xtIfiXzx7+rxhziFkJxXpsudWqRzOx9H2sUO2dI=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "3.8.0"
      "sha256-gFUauGsdVBYOulj+fcdjca5dsB10fZgHSR4Lu8jPimw=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "3.8.0"
      "sha256-kcWOiyoGrB1UNWWuV7VpEt5kKeEArEs4PoGe23t/bK8=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "3.8.0"
      "sha256-lRWxNvIQCcmjR/tmLVvkxYnwfgCfHoz2EYVRahm8AG0=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "3.8.0"
      "sha256-BKgWqSV43o37UzPsRKnPj6RxE6E/4ePkRiAGqHHlXPI=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "3.8.0"
      "sha256-FpI7drHdOFwgXibCtz3ixnObCisLqHSN3BeT4jei+eo=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "3.8.0"
      "sha256-V31ZItoG2qkiW9KxAxCUPlAqV+nJ3QrLK/v/mS+kom0=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "3.8.0"
      "sha256-NF54r4IfJX7NvetA3P/52Sq9sA31VrW1KpVE7ATgGTc=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "3.8.0"
      "sha256-One3YHAosNYL2Ln7jPNrSQX3mgxVhqq4oFFOCU/+l4A=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "3.8.0"
      "sha256-Xt4XK77VyC43S42BHwLv5MKgF7CZbnWEuW9xCyWK3ow=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "3.8.0"
      "sha256-RK+XyXCF+IscV7cj2ZG6j8LcDMTlEd/PevawvhFiZWE=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "3.8.0"
      "sha256-gjhhJoN2VBlacfkKnkWMAs48k8C4qOnKwEy5+o/LL8A=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "3.8.0"
      "sha256-BNPg4NNriaJTAxfOlLp0JLl5LXQId3HFTsVfjFjA1HY=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "3.8.0"
      "sha256-8Axab+DTO46eOwzZ0tX4uDIlmOAcgneBiCRGViSpOcM=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "3.8.0"
      "sha256-PYrHvxfRpnshmF1GVBcQcDzITbkFrsP4ccq1Y9zOP4g=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "3.8.0"
      "sha256-ywMpQzeC2otle0bztlNldRS/uROHFxL0nYpNBuQO1eE=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "3.8.0"
      "sha256-38GauiqA/jkdF0qNIZbp7b4irP9Ia9g51RZgtdhHF8I=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "3.8.0"
      "sha256-wTPXcSi5yEZglllrifVQikwynjE9L4Kj+KpQtfK2pcY=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "3.8.0"
      "sha256-XM8FkpGVemA10/9hHdx2fCNg5b6WgvoYIgSUsTvSV/k=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "3.8.0"
      "sha256-wV9YpEqlAOjU9rICDt37ZkcKa0ZNG3tekJY4kTmhJPI=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "3.8.0"
      "sha256-b6SmCzR9HmA/rR8xduAlmNdOOct5nV4WeSgRid10Yms=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "3.8.0"
      "sha256-7o/nzYUCFOwZLLcVSJNPbqrH1KZyVK8Jg2/Zl+mh2Xs=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "3.8.0"
      "sha256-ydR9t3gXKxL/uqe+vW+zcQejApzPDRc24HnZ/KrzL2U=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "3.8.0"
      "sha256-JCxfsR0UzHXOsrBi++J5VwDh1uYyDUIQtYo+bAmL19U=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "3.8.0"
      "sha256-XRVkHT5Gp9s003zFvMc8RsCnaZpyNbva5fS2qAfx1xM=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "3.8.0"
      "sha256-NJEHWLRVZJFoxZPIUIvQSioIrInbXE0qAclTy5tnHC8=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "3.8.0"
      "sha256-+RsaaqXJLhHeVfTW6HO6+bSW0vGbC40G+q+U9Jcigzs=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "3.8.0"
      "sha256-o+9kCeqw2hQX9Fp322ibvtzCpqTQkMe/iHktuPdAITg=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "3.8.0"
      "sha256-+cmwzj8WDPvK5cXPuGesyZ669NC7sWOZtW5b0tlJWp0=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "3.8.0"
      "sha256-2cJ8pt2KIO3VA3gCMmSkiYNRHIRfW0DE/Yzm9DAnCgY=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "3.8.0"
      "sha256-Lgmegzqab9m5b9Rl/KRSUp3eaqatWDXfU3MGP4K4uCU=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "3.8.0"
      "sha256-zc5u5Ox5sKOYnNsCliBOhww30/0p1kahUKKY7I6ZJLU=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "3.8.0"
      "sha256-w3IHGfGskQlZ0n8EkfVmAQtEyQq3QL8Qy+wqa7GWYHs=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "3.8.0"
      "sha256-r9pHu6rYiFNSAZWojxeMdwJPoom4fc7rgdt2GeBF0DA=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "3.8.0"
      "sha256-42jY5XnuBSHn+UodqFTDsO2ISXW3JktJ7x6Ezk+RHUQ=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "3.8.0"
      "sha256-eDU86sBPeGsMJEVpxLSiWQmXK5JbRDPO6JYO71EFo/U=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "3.8.0"
      "sha256-KaMzaT9BdazP7pgLA8kAMfePGvJU0BSknsTt4waOwHw=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "3.8.0"
      "sha256-LLwQGeiDeXTt+nFxLym/ujB0u4LkDv4CCW8C02QGsFQ=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "3.8.0"
      "sha256-CryIrBCFAhNlp39y7IXvwKoCFrrKcAU3e0Jgkcbhc0o=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "3.8.0"
      "sha256-WKG93cB2ROmTaGbESLmg1PXb3nis4xElhx/LMZdhdaA=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.2"
      "sha256-5t214U60d2kSf8bmUiEkj4OMFf3+SbNRGqLif1Rj28E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "3.8.0"
      "sha256-Zt+xUzP1Al2GpIcx+m7+VoV4QtySRX3DkNKzEZ6/6/I=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "3.8.0"
      "sha256-ct02QamX9dpPWJw3tYa9C++DBakMO7JysfXfrvD+lK8=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "3.8.0"
      "sha256-hr3Ul+sIaOdRdugw28qp2R90jFJLW2FnPR/bAUbefeM=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "3.8.0"
      "sha256-FSN6co2PwGJxC5WHqfx2ranXnaVZtGt6fg6YP5vAi3Q=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "3.8.0"
      "sha256-X6i7+USRKti8g8YAVHbTkesVfcnsrOSWMsKpDAKkzas=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "3.8.0"
      "sha256-cvzfe0KJaoiyC99BYtIiNaWWMXzZhX4NM8r0Z7eenOk=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "3.8.0"
      "sha256-RIt8f2lS3LqaYyDV8RQ///+Fx2W7KCpUAMbTJiFYLjU=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "3.8.0"
      "sha256-obYBY711W2MWWLCbSmTJu2FxzvoHzTrQnKIV9PMKySc=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "3.1.1"
      "sha256-g+XQEgqqZul8kOg0kstdYMvw2tu6zhC9GZGgs7WH3Mo=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "3.8.0"
      "sha256-SvlqVx4Bh/V62y94lcpm5xJPT98iXK4HU2xZCNRhw64=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "3.8.0"
      "sha256-q3JceBhmJlC7B3dRMy2dLgVOxReobx/C3jNHYhHGeHU=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "3.8.0"
      "sha256-rqs6/KcAqxsUBYZoqK4gGcbVSB5uPUPK5LF5G3jKcnI=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "3.8.0"
      "sha256-1M+QVMXmGcBzo8EtZcrfS65UgdE3fB4/0JHxo0paZT0=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "3.8.0"
      "sha256-Yp9+eL59DX9To5W3DYPA/KAyeLTVPYj+u7XSq1p8xzU=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "3.8.0"
      "sha256-x2LMfvIuPgte+Daas5l17wLutMsV4Q/6o6+MHrluMnI=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "3.8.0"
      "sha256-yH/6qS+AgIGa3nDNAUU1NbM2Xlg4ruaFgDSCGGoU8wY=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "3.8.0"
      "sha256-JP/iKnjMMKqhtDRdajUH1lhF+NKFfXffLmY+wqq2JFI=";

  types-aiobotocore-freetier =
    buildTypesAiobotocorePackage "freetier" "3.8.0"
      "sha256-rNwzvkTlxF2A2FWP3Jn33ncvkkd4Lfd9F4vU5oD1Ivc=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "3.8.0"
      "sha256-C5cbXS343/b+nOsGICmi7bVnDYQPDmqtIuFX1ZWxwes=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "3.8.0"
      "sha256-ucITXuJN9iJp/jpqC+IjCJCAXgC6SpQSr9Z3ZWZ/i/s=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "3.8.0"
      "sha256-MK/Li3TBbr/4ZzaWDBoSv1VaeqQubTvFkQb69niPLDY=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "3.8.0"
      "sha256-LRl5pvM93obsygIMLZindo2RJCcuSerfSYg21xZLLpw=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "3.8.0"
      "sha256-oSLmD2Q1ehanGR0e/PkRg5JDq4Tea5QrlZ6E5o+4W84=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "3.8.0"
      "sha256-baEwgysFIZ0sqLs8Ce1lCYlwWdHjoW1YcfULyd0LDr4=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "3.8.0"
      "sha256-PYy8Hq5GLsTw0fU7RBOrAxSYUD4LVOtiuyhu8vuoWLo=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "3.8.0"
      "sha256-nw84dUammVctscSvCALbHfeH+AoZTnPOWfm7EJVED3s=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "3.8.0"
      "sha256-zWSsSCpQHSM+kP02pzWHirNI6+3Vdqbw/y+svgvVpuM=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "3.8.0"
      "sha256-0QEK6HAVWTSQ1vCpW/bz+lPiZPQqu/0EE0srx9tlkcQ=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "3.8.0"
      "sha256-FmCc4A9dfpQhbzFyH5x6MDqLTsE7dsqD2sxDpKBL9L4=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "3.8.0"
      "sha256-sGFP3win2/3htNlBhIO0FPqBkFFAxwKYFTX7tOiHVBM=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "3.8.0"
      "sha256-veDFYKpW1pMd3fyIIeW5k5OhWL466PVPJ7uuNGMe91Q=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "3.8.0"
      "sha256-iq7n5X39eAEYifr2KPbYJhsbVlmuGtVy/jeb8lYCITc=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "3.8.0"
      "sha256-NtuXmbMBgOLF/S3bn1w4aaaSEcvvb/rMCoUWBmRTOE0=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "3.8.0"
      "sha256-MhtjS56BNhfyA5eLmbFXcvNnp5mzZ5JBG7dHeSRq9rI=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "3.8.0"
      "sha256-1LrGSpNbjQakyFykV4VLYuZb3aQ9vxIfTJCwjvIwuTg=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "3.8.0"
      "sha256-FCPwQNnVpGpsEvrWzWvu55/SX3Ik+NgRqbzIR6Vi6pw=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "3.8.0"
      "sha256-3krMjI51J3HQJJUc0mMQn0bPnDsTGKT4SbSBRhYWc3A=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "3.8.0"
      "sha256-ZwKbtDQDiOdlIBqS2ethhQIb/pS7PA6l1F02XTLxWw4=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "3.8.0"
      "sha256-ht3z9xaUzfshstcNk/ZcIiY7CeXK51VwbuQwj2LLRsA=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "3.8.0"
      "sha256-SDg4GdttXOGqcw0z2PRZLDmFZ0QkR80JAjzkmXXX+ds=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.16.1"
      "sha256-gnQZJMw+Q37B3qu1eYDNxYdEyxNRRZlqAsa4OgZbb40=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.16.1"
      "sha256-qK5dPunPAbC7xIramYINSda50Zum6yQ4n2BfuOgLC58=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "3.1.1"
      "sha256-Yf1vvasgtUxFiEfSrlPq0Q2yhbAOGyRATzid+qYjlj8=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "3.8.0"
      "sha256-tvbrL7uePzZqIa4F2Jz2YfXhKDpjn9zA4ZUO/xReaMo=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "3.7.0"
      "sha256-isYjEnViFGsgtRDb3Y2i9vTCjqDcB88rM8JmxhpxIII=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "3.7.0"
      "sha256-FZZowHBNWFF3pWDNZIG12vR9NbWfWNWxt+IJvZYlp3Y=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "3.8.0"
      "sha256-Yogb6BJQXzIlnKUHmDwv3MySFwjyT9zZ1l0GwFMhtSo=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "3.8.0"
      "sha256-zaypX8ZPF5KMxGPMbAGn88ZCzYOj0uqZMIgiTdJUBUA=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "3.8.0"
      "sha256-XGCAqsutuDmspoyT6SCaYiZe1mwnYA0rMP3ejNYVQts=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "3.8.0"
      "sha256-+e2DcbAcMDQTdYBsJuDHmd9ti05FMJmZ5V/DCl2nKaY=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "3.8.0"
      "sha256-5xAdeSjEA/VZUmbtOtbK5oiTwQUPDTr1rnG40+LfIx0=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "3.8.0"
      "sha256-5PR1jssqq+eKSMk6vN0M29UxFdwfdYjekZAruvgSYSg=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "3.8.0"
      "sha256-rw/PD66oAlO7Y1v6xaU54gHzwNgPhymA75gZov5KbmU=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "3.8.0"
      "sha256-yXfvCFy016YXMM5CjQ6amOnupC/sWWXlY8Ya46fy/Q0=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "3.8.0"
      "sha256-0A/W/mnF88Nhi+hI/us104wPyJ93yVtfEDF7/rfQLGA=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "3.8.0"
      "sha256-/NCIq5fPq4ou2s8ERei2FMLjaUfdAqCmoTABPjUFSxM=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "3.8.0"
      "sha256-rAAr+SlpItRjwbMhn+ZOOzE771lvbFCVJdzY5KOrnrk=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "3.8.0"
      "sha256-huXu2WzRlU0Oqi1T0pJeFbcpBdOPNX99fxm1LLD4VG4=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "3.8.0"
      "sha256-h2EEdT05YIGgMxGrJim2z2gbu9AEPPBGgLeK5NR5NSc=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "3.8.0"
      "sha256-oURHyFE4CmtYgKeh9Un4we5/jARmS2xkDVYF3BjX8CY=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "3.8.0"
      "sha256-mBIHJXjPoRLabwbhfyFHU2Wv21JdE4EBFAf/ocv95sM=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "3.8.0"
      "sha256-kgJ5SCIXcz9ztkRtOMxOkC4nv/u8PXTBmN83fa0hQ0E=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "3.8.0"
      "sha256-jyEOwGHkNQN18likJXyTv6yIv+/YJzdpvBhjDtUtg3Y=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "3.8.0"
      "sha256-SMUkYTv2NP93xpVulnBT4KBrctpA6u1lvdkH6btsnb8=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "3.8.0"
      "sha256-VaCcwzAylyh3mSLQYf4vOi7J8l+S5fH9h+h+0h9wRCo=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "3.8.0"
      "sha256-1TBFgx//FZ5iqp9Skx2Nnv3D2nCG48mIkAGdo/FgrV8=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "3.8.0"
      "sha256-1cLDZQ16ZArmsZnwcsxSngEyMKqhU/5Szwa8hMMIiTM=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "3.8.0"
      "sha256-Q3n4qm2WSxdRRz8QHqOe9cNNTRm0QWt6eC2gRklQ2bE=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "3.8.0"
      "sha256-lod8LBtkel5M9uNcGN9qHB9euCpd9mcjUtV9xDV48zE=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "3.8.0"
      "sha256-zBJGH6fWDGwvNELNYzctxiC3+22f3SI/IMS/z+iwr1E=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "3.8.0"
      "sha256-7vLLgWhsOMoPcWMsPOGudyjs0f1wV1SH4A9T2hn1Zjo=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "3.8.0"
      "sha256-jdy7WhiaiZOK6XvgHEqp1zQ/3bEs7vF8b2Pj7IJi45A=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "3.8.0"
      "sha256-1/4zdVgYZumB011ZK8+gPpUh647+rUmkskVfxdPHSgk=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "3.8.0"
      "sha256-VQD2eEuv4rsBixQJGsTV3Ndz6pcswhOB0OzBzXp/FLk=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "3.8.0"
      "sha256-f9NlmQn80W8sNI+a7un7hWI75KNwnTU5lu8kwbSmKb8=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "3.8.0"
      "sha256-8cNAO3Nz3kFIh0oGX+jdrzv0iTC7IeyzY2y8vigG1bU=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "3.8.0"
      "sha256-qk6/UDjY7eozxMOMU1nZzStLQcTGa6qzuAnIeTnp2Wk=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "3.8.0"
      "sha256-3pz254sSbO9+3n1RmGz9ijZ5yjHSWNF5Suv87BQwNPo=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "3.8.0"
      "sha256-QHPLmYurrvAqMBWK0ShxbKMjd9fMwnPtHxPF/khk7u0=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "3.8.0"
      "sha256-ZDnwMOwYDHTFGh5pO6oIO+9VSP3FrcOOvEeLL1o5+D8=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "3.8.0"
      "sha256-cOs24Ubxda0lHuEqNMWUWBRIFc+viNqzWiyhRUdtVQo=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "3.8.0"
      "sha256-ozpbCLckple24vE5SoKmrMYcG6bueGRcm9K+/h3aofA=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "3.8.0"
      "sha256-tu3INobdh97DVaVSL6jhihffTOaXAuXwMRJ7IygAM58=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "3.8.0"
      "sha256-xz7Z9lMcYt7defxAjQh1hcz3KlgaiXzXm+kuyd6K7jg=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "3.8.0"
      "sha256-WnEfs2fgIFZWgZzUVYdhWxrfvoDPpse2YilpH2FsM1s=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "3.8.0"
      "sha256-7UN+fAnnRG+Yi3dHDT+R/BgrLpHNQaN89rmfZb55Ipg=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "3.8.0"
      "sha256-lDQW4Uo/qhurLCKdXEWOPyIcdVqox23QRYtGFlnOHJM=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "3.8.0"
      "sha256-J5+DxPPGvlPd2eic4cimuwk4MGXY9p9siLHvqGxNjCs=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "3.8.0"
      "sha256-+sAcUqwa2XAUNQ4HCBhCBxwkWDR/GMmT83/naBHFio0=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "3.8.0"
      "sha256-dV1yF+Ltf7XSYkEtQptQ1XggS2+zOq7qufW2PrOQBnQ=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "3.8.0"
      "sha256-lZBE16p54nyEBLEiQKISDf6og63Ks9OOU61gUh/f6cw=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "3.8.0"
      "sha256-LIoZJQx4VquorbRYkEGSOXC3pZPtE8xBrZaYCGvjPv0=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "3.8.0"
      "sha256-UpiSk5rA6Oo7AmRenzktgyBUMriaji1hxBCfAnW7L64=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "3.8.0"
      "sha256-D83ZhZrKaiICVjxmvxp7t9ZHZM1O1Zl5cspzaULHYfw=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "3.8.0"
      "sha256-v7zj1usdOPaxmhBVnGsSqny7DlNn3Z7MUY7HFWpyfV0=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "3.8.0"
      "sha256-symkhiZs8OkjSdbp52R7TTVhih2a3unxvPKqN6CCpwQ=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "3.8.0"
      "sha256-ctWui2wOqCfTGNgrfNOLx5py2zSxx40Li6w0IWGRbmw=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "3.8.0"
      "sha256-oS1Ewj4mg0oC6Cj2rp+FxfzdhrRk4WL8eqnZIfbRGBc=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "3.8.0"
      "sha256-DKvktjROiAhR0sYL3f5Kbxf7NDmQs0cI1oXdF+H7Dc8=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "3.8.0"
      "sha256-fklKVVPLhZP86zoLgTzBWixEa6cR9qkwXOzAxcWvBHs=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "3.8.0"
      "sha256-mU044LDeWhZBVkev4uuXO8E7PGex8a6tBSuFrQk+kc8=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "3.8.0"
      "sha256-jLqguMoVgDmxp7BgcfHkJlOICBjfQ0ncr/CSuayMvUI=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "3.8.0"
      "sha256-5u4c2Iq0Z/DdoEXMeJrqRJq0Pq8y23RPCs74FZSdPj8=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "3.8.0"
      "sha256-/IDxkXpXYZ7NiwgRHr9cFqgEfyvQ3hXQAewMFPiVk78=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "3.8.0"
      "sha256-bYL2KIZEHc8HzpnOeSx5L3UxgfgW+XrG/VJ00nikbB0=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "3.8.0"
      "sha256-BxI8KWGoIxNFNXRRz0DRo2Sz5xkg9nzPtDHq+0VmutU=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "3.8.0"
      "sha256-eZNeyVD/zx1ePuw1Ugnqj5nZMzqI5Vf3FXJLHFXPKCg=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "3.8.0"
      "sha256-Q4APJE/eQ+8il1CQVEJTuVsIuNQ36On/riIfMnnqQgQ=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "3.8.0"
      "sha256-eew4+yeRvT7uUuZu1IwzP2qwHkjADvZRmTe3xSZVUHY=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "3.8.0"
      "sha256-lmcFY4eKCULjOCess2UeEqmUStpOk1DuNOqJj3EJGgw=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "3.8.0"
      "sha256-2q1Ju+70xhikArmKdIfxRXFBVUa8x3EV7/pjfA8E9YE=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "3.8.0"
      "sha256-0EHB+tUKqpKhWm3ykARXvyU5fmP+FyanPin0qn8zA6M=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "3.8.0"
      "sha256-x0xxdxHZCU8Shovn8F1YaBkEAbnKw0xWA/KPeC+BUvE=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "3.8.0"
      "sha256-aN4h4udMGDx6REgK2BDp3ADK8YHrnbSdZskr5WyMRqo=";

  types-aiobotocore-networkmonitor =
    buildTypesAiobotocorePackage "networkmonitor" "3.8.0"
      "sha256-MbEMeXR6x9Dzu6YakHlQAuwH/1hTl/+X8102SalQElE=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "3.8.0"
      "sha256-VoK+31HqheJv4WW95RbH0MEGIeBskZ0JHrVpgKqYjuM=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "3.8.0"
      "sha256-4nhGLCkM0qiAK35yBFbhGSG7gJVsiiqv67lJRb12YiM=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "3.8.0"
      "sha256-d0jbWssa20R1iLeDfBB01C7p2Kc0C7ILc/RrJOLD6q4=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "3.8.0"
      "sha256-zMrlnrUdt587repiH9siJvBrC81v5DB6OcXuKyZ/RRM=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "3.8.0"
      "sha256-JaIvQwOaTvvXCgTwZGTzi6lRpZRS953Mc/MjZDHiNNI=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "3.8.0"
      "sha256-hSk0D2JRC2DSG8qkpig2nMdwzAj5PoBNwpZmAtmgWMo=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "3.8.0"
      "sha256-dYBP/dI9HUhmGfLJYl4+/RH801h27N8yAcHMS4VX4T8=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "3.7.0"
      "sha256-yn1EAIvzNfFR1a3r8y9Ri5nOdprgEAYBuXw2Wt1hYIs=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "3.8.0"
      "sha256-4q1QYDmeVcxIkNq7z0OIE1aK8seWKhJtqFsaZQ5oC/Y=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "3.8.0"
      "sha256-eGgQ9EM3ZMX/wpuyN7bU10IBD+k4WfuQ6vhbvFsOGaY=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "3.8.0"
      "sha256-gTNNWV3BfpW+8RxChIT/020o0pP7fJV5XmQ0aHVpe1I=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "3.8.0"
      "sha256-B1eYaw8kVq5VdCLvbHYdsAiKGi3gAAUDBt3SxH3o1ak=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "3.8.0"
      "sha256-Ja/Ul0q7BwrKzC9+snrsYzVfB6PZ5tmNDgCWl0Hmp8Q=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "3.8.0"
      "sha256-WU4COLkd+390YWKb8UdxZUL5OOi0lEXqPkBJUxAMBAw=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "3.8.0"
      "sha256-1KPJkHGhHqATvvzeQLTyX09DtxUhtfSRBqWOs/SGF6c=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "3.8.0"
      "sha256-+2FHKZX4d7dY7q/wlw0he8wQb7fi1nMcq9tiLsP4a1o=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "3.8.0"
      "sha256-NtGcQU1j+LXng/BYGex7ftL3rtQJKDtZPuhKKSiZGtE=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "3.8.0"
      "sha256-mi5hfaAROkvhfYBAXQr1CPjGoOLqMsVjkqYmTQQDsBg=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "3.8.0"
      "sha256-P2Hu+qj36SDxpf9GXxpNc8aMTaxiIAsefT1eeLtAe6g=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "3.8.0"
      "sha256-Ylsp/MRIw3oCh21QUp0/8TzqwKmAmo7xxcVB8t7iNCQ=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "3.8.0"
      "sha256-0UYCz0HdXkycYk+w2E4H/AVrGWaFpQ94utXyBieiNO4=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "3.8.0"
      "sha256-x73B2DyuhOGtTBZwuoG7s/USu4c29Qs2mq9Qjc6SOYg=";

  types-aiobotocore-qapps =
    buildTypesAiobotocorePackage "qapps" "3.8.0"
      "sha256-bXh+xsVd2Rzgz0ze73e6UqTyFR8V1mcNr+FGqIYotcw=";

  types-aiobotocore-qbusiness =
    buildTypesAiobotocorePackage "qbusiness" "3.8.0"
      "sha256-9E6QJ9/jEwo4Zm1vrSX8LmSvk0rNr63iAwyn5A3FipE=";

  types-aiobotocore-qconnect =
    buildTypesAiobotocorePackage "qconnect" "3.8.0"
      "sha256-AAQfQECzT/PGyU3ZPlRAJdcKKe0oBejIcN+Uvg4Ae8Y=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "3.8.0"
      "sha256-Hy4YuHmQLl+8aQo+HNsaUhHlHx7ImLwVrV5XU1jp4Tg=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "3.8.0"
      "sha256-8pj/XXHLXRqvWBNsVoKubplfV69aSVpHZnJKCU3Jijw=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "3.8.0"
      "sha256-66izw8WsRm5ry3antqdF4z8KEjqJkdqcICi1/gJvIJw=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "3.8.0"
      "sha256-hYAZVdOkeDg1yQmnMj+3+obf776Q/hTJMdEJciROF54=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "3.8.0"
      "sha256-s7sEAW5AfVxmDRIqFydLFSrkKfVZkSDrJ8ddO7VbOxU=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "3.8.0"
      "sha256-tM5tEgTsiv6wwcogndckhahT1sX6jwW9gi8PqOR7QR8=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "3.8.0"
      "sha256-FKAr4sj2PlnWylszTjEo6pi6uyyIs9dUJgN5Z+PvF5c=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "3.8.0"
      "sha256-Q+2u1devvhGEhfrngDMtjieU4NomJW3qUIuEKC4Edrc=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "3.8.0"
      "sha256-p1VZoe1+XZjBR1vY+0ndaJpwQB2ETA8dCSqzB/nS6ds=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "3.8.0"
      "sha256-ivZzzqLmWBduboe0I8jLcN5uTmjYXdSMsN3lFYxfbP4=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "3.8.0"
      "sha256-lrvZj2al00KLmIhR/TESNrAdr78QWoCPZNlw171/tkM=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "3.8.0"
      "sha256-gNjVc/S4ulJRIuzoUxCA1ZGgsdhrxIQnAsqUtSj0UsA=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "3.8.0"
      "sha256-RnOTj6xMBmzoujaGvdoml6Uek2zTSVqmMxFIh1VFPzI=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "3.8.0"
      "sha256-UUEMJgKqy37F8VxCYjjEsbrtD4vlunpFhjt0i9otsGE=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "3.8.0"
      "sha256-BQ4Hyr2WZxohigUVtrOfoHiSfWd/eij8RASwTmoxo/M=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "3.8.0"
      "sha256-s6Vq+JkwQLDiqb9jTkp0YL7jIo9Lu9G/wQwqsWxzuZw=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "3.8.0"
      "sha256-hcA0U0R3ZyKUTYnERs0WLSAYKnZHV1HpH8rcMFKLqHE=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "3.8.0"
      "sha256-L0FeJ+byISjFt8/W79yNPGDEnvFoNGD8yM3/yXaMQd4=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "3.8.0"
      "sha256-xbAEjsrXh3FQFRh6KOK0yiYC1fcT9yMxMNHOS87c0r4=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "3.8.0"
      "sha256-MHfRAsJk8bqPKO8oJb5fHcW4gY3BuAMCfuhgVZPOWzw=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "3.8.0"
      "sha256-KYOgvIR9GrLyeZiuIXALDgxQ99syNCtu/GjsSTeC1Bc=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "3.8.0"
      "sha256-RdQ3aM9XbMfBEJfbbEgGw6zF2o3KDw4OE7dYnd6NuJo=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "3.8.0"
      "sha256-ACHYla+TkOioQ0/PBb5+oKMQflivMMjLajabtem1N98=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "3.8.0"
      "sha256-oiGGCykPW9XdpqOdpeiouogncL+wYVWCCETElnu80i4=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "3.8.0"
      "sha256-r+nTiRlfE0u3R6cYkY7G25Mtwu27nm1306rK44dXNWU=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "3.8.0"
      "sha256-H2nsfkX1WhVuRTx1txaeViz7xl/MghJIDrRE6frdPuA=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "3.8.0"
      "sha256-6pXXypzArZxnRLPo2QPGJG1QUA8QFv71+g+OmTCKwuE=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "3.8.0"
      "sha256-33uAsVV9vWVuwUZ54nFSRRPmX4hL+yUBoVtrRroexdA=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "3.8.0"
      "sha256-y+Wvl2d5w98jH/EWw+itdU2OexegO9BYpQVfu6qqDV4=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "3.8.0"
      "sha256-uPlVbZxKBt3AbcauBjFFGXGrNe0tNCRQCkBVxWTf3KE=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "3.8.0"
      "sha256-/hhyDFyLfUqvLj5rTqGA1Za0YovELykHF4nEZmwcURg=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "3.8.0"
      "sha256-t25/mSJtBuk93SB4wHJCxkPPAmGzhEjDnJ55Bg34ONg=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "3.8.0"
      "sha256-7t1Se3hvhUH0+ie5Z8ZmSdH/YIQrS6AA6un3GBs0OL8=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "3.8.0"
      "sha256-nRFhabmiXsbrxP/mFCZrlia7II/VPxFWOci3/phJIbk=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "3.8.0"
      "sha256-SGybv5JCy/H4APcuz6G5iyTWRvznPzE0FMB1iZhfeYU=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "3.8.0"
      "sha256-+xh+UAk7IV4B2NBynoo9zDCP8vuZbqMTFigj9xWziT0=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "3.8.0"
      "sha256-F4GXvzkqRuKYrSz+vgNUH8kNlC+6QTV1uuTrjoju8JQ=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "3.8.0"
      "sha256-VdDzfaUL/UKSa5bdwAEbUCvL4+5Y/Ln9cDy11bNGA9c=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "3.8.0"
      "sha256-0dsd7Vk5bSDNkIA4I1oSTkFnDGvBdo3U/PrBOeOln/M=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "3.8.0"
      "sha256-fVwqzxnmY0bV9r5XxLzibVI5yVr/Gq+8pc8/ZwGIQCU=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "3.8.0"
      "sha256-SJgWdSispGZJa/Rd5AjpGoHObS9XcNSLUXKFlDE3Kyo=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "3.8.0"
      "sha256-OBQBp0ABQ98rd6xGwMRz7LNpN/gZwEMmQG0jEPWY4hI=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "3.8.0"
      "sha256-MXCvhBB4Hh8FDICYtTJ5284IvLHtQ5RE5mbh5kr0+z0=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "3.8.0"
      "sha256-Ciwb1+TWafzjk/IMbbDl37unH/9HO17seKfubLIhZvA=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "3.8.0"
      "sha256-eceYxj0YsHoGGyxLb7IaAw4NTIFhQRZDZBrgZpz7eAA=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "3.8.0"
      "sha256-Ef7eR/fxBm5U0AtMng/igDSwnprh8Qsp34zDsq7Uzyc=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "3.8.0"
      "sha256-7bZO7gE9YDlozJLVBLXEjhY6Qvpyqd/lZJ8DJa9+Tl4=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "3.7.0"
      "sha256-tZQL781zQI+vVvO0S3cHzw5RGAHKXeNeJW7E8tzCHA4=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "3.8.0"
      "sha256-2uis1mOwbktudjIYjILsnj/4mIiRUZ51Oopby77rae0=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "3.8.0"
      "sha256-xXv7nW94TeCdu5iIPG06NAm580G6qnSYZpHrYJndCwE=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "3.8.0"
      "sha256-Yg7DrHAZchgrY3Y0xV3bKWoeH6G7uhlNiZri5wJB3V0=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "3.8.0"
      "sha256-g0G0TfsbpBWWz0sCBVBpGCTT7XsQxpkgzIJm6C4Ffzw=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "3.8.0"
      "sha256-n++L1/HS0lJAZvbreLHF2jsfYCouxBQ1YwAxccZXh3Y=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "3.8.0"
      "sha256-waBPsdCb6VYHl4ksss+5NBWS5TIDuy5PIjRUa5hjcFU=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "3.8.0"
      "sha256-RT88KQ13QWrwm3CidVSZOtG4KcBP4vatFpVytUI+bhs=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "3.8.0"
      "sha256-7V7gm8gtycscQ7ZHJvitcL/sMgjV6FB/O3c4matZKig=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "3.8.0"
      "sha256-dkcBJ6jrBcHEKdQksTmsFfAer2G2g4spMTbMa/BjD/4=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "3.8.0"
      "sha256-24C5jazNxBBmF3bapfJKM90T8kR5C08jazah/iAEI4g=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "3.8.0"
      "sha256-YFKPlVoOz3hrCDYHAk5ZWIB6XjA3Kua/fFfFgOZgkCg=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "3.8.0"
      "sha256-OTgBMoSvpWIJHqdvkq/7efLEwghx8eu/+9N4Qrv040M=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "3.8.0"
      "sha256-9cWYie+8XvIV9lX8xQNM5HDmidnJHrYh7a6J8BsoNms=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "3.8.0"
      "sha256-DU2fZML4blGFKvylKqZab+YMCbM2my849IaxqlqtyVs=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "3.8.0"
      "sha256-o5Jt9CqyS34SHFTfiLs/wvV/eMGufPDubSwTFKWS4CU=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "3.8.0"
      "sha256-kWwhVzvk2Lb2FBcW08AUVglmYG1vSMQxXUap54ZDZLk=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "3.8.0"
      "sha256-TUaFgJ4Y5tO3XraJye89wCRfYXSx90MlqYuq9R1A3IE=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "3.8.0"
      "sha256-jfzuXQ8+MEU7darrbKA/mSl8L+ibv3HoiVwWJAkSnEE=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "3.8.0"
      "sha256-OZ2u0vQ+mjzG49shUSFJTdsS9FamI2u2bkceHGRjoVs=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "3.8.0"
      "sha256-fIda+RpLRbalAAdWfg8aEHzNn+9Es7KllHQz1B4K8WA=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "3.8.0"
      "sha256-AA3OeQ9BZY3R70RVDbQCPtyrPNj3YNtSNh1z3f9qiDs=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "3.8.0"
      "sha256-/FDrVBs47zsYp4bSZ2OV5u7tFk12mafWG6eWle4iYII=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "3.8.0"
      "sha256-1mIDDrE21TtgOMJfx4jzuk7DhmNLvhTsGrVnc3EhEN4=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "3.8.0"
      "sha256-yUs2TlnOm3CaTdGEy8aYxuOHs6XWaolarAiR+3Tm3/4=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "3.8.0"
      "sha256-j+KY5PmGWI+dyeIo4MZ3P2bryKqSmmroUaESltrcfjE=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "3.8.0"
      "sha256-nUBL8bCx82J0oiwzqUOImTUmd2s06uVaSWkf45RSk/I=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "3.8.0"
      "sha256-8CJ9xIl5fioWFFbQsM5tio0I+YHKYwxHyu+PwQWIZi0=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "3.8.0"
      "sha256-AS2+zlRaFYuNccjqJtrm1nbOWjLvOV6ebEd0KVowVd8=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "3.8.0"
      "sha256-/uqK6vPLwkzvFex65viLJsjBHhOwoObw14D6nDRYG/k=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "3.8.0"
      "sha256-WSye8Luy3Ka3q0VIkJeb0CQDMACsbeQg1cNI4mhSsxU=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "3.8.0"
      "sha256-w/q1rs8RydoPVuvH1JnJ5v+yhRjLEktCxrCfm0vipjY=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "3.8.0"
      "sha256-obED8QWKS/GYlahstqD35Xa1GZJDwvRBnDuu4t4RolQ=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "3.8.0"
      "sha256-WYddHMQ926qOq3uC2NbJqIxvTUqQc9K6/Q/6yExXofY=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "3.8.0"
      "sha256-HFX9gJ/e+Fay413zlroZuB+6QXlF47iSh3ig3o9iIDE=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "3.8.0"
      "sha256-sI+SvwTATHYr5IDem+i866tLgbNMP8VrWu16KPcVCfY=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "3.8.0"
      "sha256-yj6tbGemI+hxc/R/OkEtVJyDFaLZFUaA3MKaGHXLyfs=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "3.8.0"
      "sha256-6T/dUHKa+MtgcY/G34jbtgqLEgu+g3wvgOj/atfMRc0=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "3.8.0"
      "sha256-qN/e24/cufnOIzI9o4Mqfr6jylEIBmghVz6zftzwp+k=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "3.8.0"
      "sha256-QpfiMYudHgjgJUWsqBxzghNiojH6VZEOa7DgpPk7vPk=";
}
