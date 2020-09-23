class ApplicationController < ActionController::Base
    before_action :require_login
    before_action :set_locale

    protected

    def not_authenticated
        redirect_to login_path
    end

    def set_locale
        I18n.locale = current_user&.locale || :ja
    end
end
