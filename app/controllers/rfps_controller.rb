#coding: utf-8
class RfpsController < ApplicationController
  before_filter :set_spot

  def index
    @search = @spot.rfps.connected.search(params[:search])
    page = params[:page].to_i
    @rfps= @search.page(page)
    if (@rfps.all.empty?) && (page > 1)
      @rfps = @search.page(page -1)
    end
  end

  def new
    @rfp = @spot.rfps.new(:agent_id => params[:agent_id], :from_spot => true)
  end

  def create
    Rfp.delete_by_spot_id_and_agent_id(@spot.id, params[:rfp][:agent_id])
    @rfp = @spot.rfps.new(params[:rfp])
    @rfp.from_spot = true
    @rfp.status = 'c'
    if @rfp.save
      @spot.sent_messages.create!(:message_to => Agent.find(params[:rfp][:agent_id]),
                                  :content => "#{@spot.name}已经为您开通了预订", :read => false)
      redirect_to rfps_path, :notice => "创建已成功"
    else
      render :action => 'new'
    end
  end

  def edit
    @rfp = @spot.rfps.find(params[:id])
  end

  def update
    @rfp = @spot.rfps.find(params[:id])
    if @rfp.update_attributes(params[:rfp])
      redirect_to rfps_path, :notice => "修改已成功"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @rfp = @spot.rfps.find(params[:id])
    @rfp.destroy

    @spot.sent_messages.create!(:message_to => Agent.find(@rfp.agent_id),
                                :content => "#{@spot.name}已经关闭了您的预订", :read => false)
    redirect_to rfps_url, :notice => "删除已成功."
  end

  def edit_accept
    @rfp = @spot.rfps.where(:agent_id => params[:id], :status => 'a').first
  end

  def accept
    @rfp = @spot.rfps.find(params[:id])
    @rfp.agent_price_id = params[:rfp][:agent_price_id]
    @rfp.team_payment_method = params[:rfp][:team_payment_method]
    @rfp.individual_payment_method = params[:rfp][:individual_payment_method]
    @rfp.status = "c"
    if @rfp.save
      @spot.sent_messages.create!(:message_to => Agent.find(@rfp.agent_id),
                                  :content => "#{@spot.name}已经通过了您的预订申请", :read => false)
      redirect_to applied_spot_agents_path, :notice => "接受已成功"
    else
      render :edit_accept
    end
  end

  def reject
    @rfp = @spot.rfps.where(:agent_id => params[:id], :status => 'a').first
    @rfp.status = 'r'
    @rfp.save
    @spot.sent_messages.create!(:message_to => Agent.find(@rfp.agent_id),
                                :content => "#{@spot.name}已经拒绝了您的预订申请", :read => false)
    redirect_to applied_spot_agents_path, :notice => "拒绝已成功"
  end

end
