export type Args = Array<string>;
export type Vars = Record<string, string>;
export type VirtualFile = {
  path: string;
  content: string;
  isReal: boolean;
};
export type Console = {
  stderr?: string;
  stdout?: string;
  code?: number;
};
export type Fixture = {
  inputs: {
    args: Args;
    files: Array<VirtualFile>;
  };
  outputs: {
    files: {
      actual?: Array<VirtualFile>;
      expected: Array<VirtualFile>;
    };
    console: {
      actual?: Console;
      expected: Console;
    };
  };
};
export type PreFn = () => Promise<(() => Promise<void>) | void>;
export type Test = {
  name: string;
  fixture: Fixture;
  preFn?: PreFn;
};
export type VirtualFS = Record<string, string>;
export type NestedVirtualFS = Record<string, VirtualFS>;
