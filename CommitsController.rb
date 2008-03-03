#
#  CommitsController.rb
#  GitNub
#
#  Created by Justin Palmer on 3/2/08.
#  Copyright (c) 2008 Active Reload, LLC. All rights reserved.
#

require 'osx/cocoa'
require 'md5'

class CommitsController < OSX::NSObject
  attr_reader :commits 
  attr_reader :commit
  attr_reader :branches
  
  ib_outlet :commits_table
  ib_outlet :branch_select
  
  def awakeFromNib  
    @repo = Grit::Repo.new("/Users/Caged/dev/onceuponatime/xtt")
    @commits = @repo.commits('master', 50)
    @commits_table.reloadData
    
    @branch_select.removeAllItems
    @repo.branches.each do |branch|
      @branch_select.addItemWithTitle(branch.name)
    end
  end
  
  # DataSource Methods
  def tableViewSelectionDidChange(notification)
    
  end
  
  def numberOfRowsInTableView(table_view)
    @commits ? @commits.size : 0
  end
  
  def tableView_objectValueForTableColumn_row(table_view, table_column, row)
    @commit = @commits[row]
    return nil
  end
  
  def primaryTextForCell_data(cell, data)
    return data.message.to_s
  end
  
  def secondaryTextForCell_data(cell, data)
    return %(by #{data.committer.name} on #{data.committed_date.strftime("%A, %b %d, %I:%m %p")})
  end
  
  def iconForCell_data(icon, data)
    NSImage.alloc.initWithContentsOfURL(NSURL.URLWithString("http://www.gravatar.com/avatar.php?gravatar_id=#{MD5.hexdigest(data.committer.email)}&size=36"))
  end
  
  def dataElementForCell(cell)
    return @commit
  end
end
