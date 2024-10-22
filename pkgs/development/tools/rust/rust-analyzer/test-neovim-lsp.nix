{ runCommand, cargo, neovim, rust-analyzer, rustc }:
runCommand "test-neovim-rust-analyzer" {
  nativeBuildInputs = [ cargo neovim rust-analyzer rustc ];

  testRustSrc = /* rust */ ''
    fn main() {
      let mut var = vec![None];
      var.push(Some("hello".to_owned()));
    }
  '';

  # NB. Wait for server done type calculations before sending `hover` request,
  # otherwise it would return `{unknown}`.
  # Ref: https://github.com/rust-lang/rust-analyzer/blob/7b11fdeb681c12002861b9804a388efde81c9647/docs/dev/lsp-extensions.md#server-status
  nvimConfig = /* lua */ ''
    local caps = vim.lsp.protocol.make_client_capabilities()
    caps["experimental"] = { serverStatusNotification = true }
    vim.lsp.buf_attach_client(vim.api.nvim_get_current_buf(), vim.lsp.start_client({
      cmd = { "rust-analyzer" },
      capabilities = caps,
      handlers = {
        ["experimental/serverStatus"] = function(_, msg, ctx)
          if msg.health == "ok" then
            if msg.quiescent then
              vim.cmd("goto 23") -- let mut |var =...
              vim.lsp.buf.hover()
            end
          else
            print("error: server status is not ok: ")
            vim.cmd("q")
          end
        end,
        ["textDocument/hover"] = function(_, msg, ctx)
          if msg then
            -- Keep newlines.
            io.write(msg.contents.value)
            vim.cmd("q")
          end
        end,
      },
      on_error = function(code)
        print("error: " .. code)
        vim.cmd("q")
      end
    }))
  '';

} ''
  # neovim requires a writable HOME.
  export HOME="$(pwd)"

  cargo new --bin test-rust-analyzer
  cd test-rust-analyzer
  cat <<<"$testRustSrc" >src/main.rs
  cat <<<"$nvimConfig" >script.lua

  # `-u` doesn't work
  result="$(nvim --headless +'lua dofile("script.lua")' src/main.rs)"
  echo "$result"
  [[ "$result" == *"var: Vec<Option<String>>"* ]]
  touch $out
''
