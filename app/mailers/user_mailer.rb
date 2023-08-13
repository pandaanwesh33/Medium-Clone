class UserMailer < ApplicationMailer
    def share_list_email(user, list, shareable_link)
        @user = user
        @list = list
        @shareable_link = shareable_link
        mail(to: @user.email, subject: 'Share List with Friends')
      end
end
