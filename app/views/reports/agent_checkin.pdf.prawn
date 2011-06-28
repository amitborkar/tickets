#encoding: utf-8
prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf"
  pdf.text "#{@agent.name}入园报表(#{@start_time.to_date}~#{@end_time.to_date})",:size => 30

  pdf.move_down 30
  pdf.table [[@table.count_sum, @table.adult_ticket_sum.to_i, @table.child_ticket_sum.to_i, @table.price_sum.to_i]], :border_style => :grid,:width => 600,
            :headers => ["订单总数", "成人总数", "儿童总数", "总价"],
            :align => {0 => :left, 1 => :right, 2 => :right}
end