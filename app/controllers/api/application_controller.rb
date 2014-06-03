module Api
  class ApplicationController < ActionController::Base
  
    wrap_parameters format: [:json]
  
    protect_from_forgery with: :exception

    protected

      def require_login
        if !logged_in?
          render :status => :unauthorized, :text => 'unauthorized'
        end
      end

      ## override sorcery login from other sources because we don't have cookies 

      def login_from_other_sources
        false
      end

      def page_params
        {:page => (params[:page] || 1), :per_page => (params[:per_page] || 40)}
      end

      def default_order
      end

      def order
        if params[:sort_by]
          "#{ params[:sort_by] }  #{ params[:order] || 'DESC' }"
        else
          self.default_order || 'created_at DESC'
        end
      end
  end

end
