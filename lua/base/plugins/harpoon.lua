return {
  {
    'ThePrimeagen/harpoon',
    config = function()
      require 'custom.keys'
      local mark = require 'harpoon.mark'
      local ui = require 'harpoon.ui'
        mapp('n', '<leader>a', mark.add_file, "Add file to harpoon")
        mapp('n', '<leader>H', ui.toggle_quick_menu, 'toggle harpoon picker')
        mapp('n', '<leader>1', function() ui.nav_file(1) end,"Harpoon Jump File 1")
        mapp('n', '<leader>2', function() ui.nav_file(2) end,"Harpoon Jump File 2")
        mapp('n', '<leader>3', function() ui.nav_file(3) end,"Harpoon Jump File 3")
        mapp('n', '<leader>4', function() ui.nav_file(4) end,"Harpoon Jump File 4")
        mapp('n', '<leader>5', function() ui.nav_file(5) end,"Harpoon Jump File 5")
        mapp('n', '<leader>6', function() ui.nav_file(6) end,"Harpoon Jump File 6")
        mapp('n', '<leader>7', function() ui.nav_file(7) end,"Harpoon Jump File 7")
    end,
  },
}

