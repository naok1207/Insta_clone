class ApplicationController < ActionController::Base
    before_action :require_login
    # before_action :set_locale
    before_action :set_search_posts_form

    protected

    def not_authenticated
        redirect_to login_path
    end

    private

    def set_search_posts_form
        @search_form = SearchPostsForm.new(search_posts_params)
    end

    def search_posts_params
        params.fetch(:q, {}).permit(:body)
    end
    # def set_locale
    #     I18n.locale = current_user&.locale || :ja
    # end
end
