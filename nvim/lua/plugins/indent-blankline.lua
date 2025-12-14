return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",

  opts = {
    -- Character used for indentation
    indent = {
      char = "▏",
    },

    -- Scope settings
    scope = {
      show_start = false,       -- Do not highlight start of scope
      show_end = false,         -- Do not highlight end of scope
      show_exact_scope = false, -- Do not highlight the exact scope
    },

    -- Exclude certain filetypes from indent guides
    exclude = {
      filetypes = {
        "help",
        "startify",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "Trouble",
      },
    },
  },
}
