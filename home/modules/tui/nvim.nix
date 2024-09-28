{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    tree-sitter
    prettierd
    nodePackages.vscode-langservers-extracted
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    userCommands = {
      "FormatDisable" = {
        command.__raw = ''
          function(args)
            if args.bang then
              vim.b.disable_autoformat = true
            else
              vim.g.disable_autoformat = true
            end
          end
        '';
        bang = true;
        desc = "Disable autoformat-on-save";
      };
      "FormatEnable" = {
        command.__raw = ''
          function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
          end
        '';
        desc = "Re-enable autoformat-on-save";
      };
    };

    autoCmd = [
      {
        event = "FileType";
        pattern = [
          "tex"
          "latex"
          "markdown"
        ];
        command = "setlocal spell";
      }
    ];

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    filetype = {
      extension = {
        templ = "templ";
      };
    };

    keymaps = [
      {
        mode = [ "v" ];
        key = "J";
        action = ":m '>+1<CR>gv=gv";
      }
      {
        mode = [ "v" ];
        key = "K";
        action = ":m '<-2<CR>gv=gv";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<Space>";
        action = "<Nop>";
        options.silent = true;
      }
      {
        mode = [ "n" ];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = [ "n" ];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          silent = true;
        };
      }
    ];

    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "storm";
      };
    };

    opts = {
      completeopt = [
        "menu"
        "menuone"
        "noselect"
      ];
      cursorline = true;
      number = true;
      relativenumber = true;
      scrolloff = 8;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      hlsearch = false; # disable search highlighting
      mouse = "a";
      clipboard = "unnamedplus";
      breakindent = true;
      spelllang = "en_gb";
      undofile = true;
      ignorecase = true; # case insensitive searching
      smartcase = true; # unless a capital is used or \C
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      termguicolors = true;
    };

    plugins = {
      which-key = {
        enable = true;
      };
      lazygit.enable = true;
      none-ls = {
        enable = true;
        sources = {
          formatting = {
            # prettierd.enable = true;
            nixfmt = {
              enable = true;
              package = pkgs.nixfmt-rfc-style;
            };
          };
        };
      };
      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-Space>" = "cmp.mapping.complete {}";
            "<CR>" = ''
              cmp.mapping.confirm {
              	      behavior = cmp.ConfirmBehavior.Replace,
              	      select = true,
              	    }'';
            "<Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, { 'i', 's' })";
            "<S-Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, { 'i', 's' })";
          };
          sources = [
            { name = "luasnip"; }
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "nvim_lsp_signature_help"; }
            {
              name = "buffer";
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs"; # Words from other buffers are suggested
            }
          ];

          completion.autocomplete = [ "TextChanged" ];
        };
      };
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end
              return { timeout_ms = 500 }
            end
          '';
          notify_on_error = true;
          formatters_by_ft = {
            bash = [
              "shellcheck"
              "shellharden"
              "shfmt"
            ];
            javascript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            html = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            css = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            scss = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            javascriptreact = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            typescript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            typescriptreact = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            nix = {
              "lsp_format" = "fallback";
            };
            markdown = {
              "lsp_format" = "fallback";
            };
            yaml = {
              "lsp_format" = "fallback";
            };
            json = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            go = {
              "lsp_format" = "fallback";
            };
            terraform = {
              "lsp_format" = "fallback";
            };
            "_" = [
              "squeeze_blanks"
              "trim_whitespace"
              "trim_newlines"
            ];
          };
          formatters = {
            shellcheck = {
              command = pkgs.lib.getExe pkgs.shellcheck;
            };
            shfmt = {
              command = pkgs.lib.getExe pkgs.shfmt;
            };
            shellharden = {
              command = pkgs.lib.getExe pkgs.shellharden;
            };
            squeeze_blanks = {
              command = pkgs.lib.getExe' pkgs.coreutils "cat";
            };
          };
        };
      };

      luasnip = {
        enable = true;
      };
      fugitive = {
        enable = true;
      };
      lualine = {
        enable = true;
        settings.options = {
          component_separators = {
            left = "|";
            right = "|";
          };
          section_separators = {
            left = "";
            right = "";
          };
        };
      };
      indent-blankline = {
        enable = true;
      };
      comment = {
        enable = true;
      };

      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = {
              text = "+";
            };
            change = {
              text = "~";
            };
            delete = {
              text = "_";
            };
            topdelete = {
              text = "‾";
            };
            changedelete = {
              text = "~";
            };
          };
        };
      };
      harpoon = {
        enable = true;
        enableTelescope = true;
        keymaps = {
          addFile = "m";
          navFile = {
            "1" = "<C-1>";
            "2" = "<C-2>";
            "3" = "<C-3>";
            "4" = "<C-4>";
          };
          toggleQuickMenu = "<C-e>";
        };
      };
      treesitter = {
        enable = true;
        nixvimInjections = true;

        settings = {
          indent.enable = true;
        };
      };
      treesitter-textobjects.enable = true;
      lsp = {
        enable = true;
        servers = {
          templ.enable = true;
          gopls.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;
          astro.enable = true;

          intelephense = {
            enable = true;
            rootDir = ''
                            function(fname)
              								local util = require 'lspconfig.util'
              								local path = util.search_ancestors(fname, function(path)
              									if util.path.is_file(util.path.join(path, 'composer.lock')) then
              										return path
              									end
              								end)

              								if path ~= nil then
              									return path
              								else
              									return util.find_git_ancestor(fname)
              								end
              							end
            '';
          };

          html.enable = true;
          jsonls.enable = true;
          cssls.enable = true;

          ts-ls = {
            enable = true;
            rootDir = ''
                            function (filename, bufnr)
              								local util = require 'lspconfig.util'
                            	local denoRootDir = util.root_pattern("deno.json", "deno.jsonc")(filename);
                            	if denoRootDir then
                            		return nil;
                            	end
                            	return util.root_pattern("package.json")(filename);
                            end
            '';
            extraOptions = {
              single_file_support = false;
            };
          };
          denols = {
            enable = true;
            rootDir = ''
                            function (filename, bufnr)
              								local util = require 'lspconfig.util'
                            	return util.root_pattern("deno.json", "deno.jsonc")(filename);
                            end
            '';
          };
          terraformls.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
        keymaps = {
          lspBuf = {
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
            "gd" = "definition";
            "gI" = "implementation";
            "<leader>D" = "type_definition";
            "K" = "hover";
            "<C-k>" = "signature_help";
            "gD" = "declaration";
            "<leader>wa" = "add_workspace_folder";
            "<leader>wr" = "remove_workspace_folder";
            "<leader>wl" = "list_workspace_folders";
            "<C-f>" = "format";
          };
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>e" = "open_float";
            "<leader>q" = "setloclist";
          };
        };
      };
      fidget = {
        enable = true;
      };
      nvim-autopairs = {
        enable = true;
      };
      mini.modules = {
        icons.enable = true;
        mockDevIcons.enable = true;
      };
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
        keymaps = {
          "<leader>?" = "oldfiles";
          "<leader><Space>" = "buffers";
          "<leader>gr" = "lsp_references";
          "<leader>ds" = "lsp_document_symbols";
          "<leader>ws" = "lsp_dynamic_workspace_symbols";
          "<leader>gf" = "git_files";
          "<leader>sf" = "find_files";
          "<leader>sh" = "help_tags";
          "<leader>sw" = "grep_string";
          "<leader>sg" = "live_grep";
          "<leader>sd" = "diagnostics";
          "<leader>st" = "treesitter";
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-rhubarb
      plenary-nvim
      supermaven-nvim
    ];
    extraConfigLua = ''
      require('supermaven-nvim').setup({
        keymaps = {
          accept_suggestion = "<C-Tab>",
        },
      })
    '';
  };
}
