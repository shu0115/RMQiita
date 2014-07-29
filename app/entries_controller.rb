class EntriesController < UITableViewController
  # ビューが読み込まれた後で実行されるメソッド
  def viewDidLoad
    super
    @tag = 'RubyMotion'
    self.title = @tag # ナビゲーションバーのタイトルを変更
    @entries = [] # 取得したエントリをこのインスタンス変数に格納
    url = "https://qiita.com/api/v1/tags/#{@tag}/items"

    # 前回に引き続き BubbleWrap を使う
    BW::HTTP.get(url) do |response|
      if response.ok?
        json = BW::JSON.parse(response.body.to_s)
        @entries = json
        self.tableView.reloadData # テーブルをリロード
      else
        p response.error_message
      end
    end
  end

  # テーブルの行数を返すメソッド
  def tableView(tableView, numberOfRowsInSection:section)
    @entries.count
  end

  # テーブルのセルを返すメソッド
  ENTRY_CELL_ID = 'Entry'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(ENTRY_CELL_ID)

    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:ENTRY_CELL_ID)
    end

    entry = @entries[indexPath.row]

    # ラベルをセット
    cell.textLabel.text = entry['title']
    cell.detailTextLabel.text = "#{entry['updated_at_in_words']} by #{entry['user']['url_name']}"
    cell
  end
end

