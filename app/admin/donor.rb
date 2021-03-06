ActiveAdmin.register Donation, as: 'Donor' do
    menu false
    # menu priority: 4
    permit_params :donation
    
    index title: 'Donors' do
        selectable_column
        column "Donor" do |don|
            if (:user_id != 0) then
                user = User.find_by id: don.user_id
                link_to "#{user.name}", admin_donor_path(user)
            elsif (:organization_id != 0) then
                org = Organization.find_by id: don.organization_id
                link_to "#{org.name}", admin_organization_path(org)
            end
        end
        column :email
        column "Phone" do |user|
            simple_format("H: " + user.home_phone.to_s + "\nW: " + user.work_phone.to_s)
        end
        column "Interests" do |user|
            user.interests.map(&:name).join(", ")
        end
        column "Donated" do |user|
            # sum = 0
            # user.donations.each do |don|
            #     sum += don[:amount]
            # end
            # user.donated = sum
            # number_with_precision(sum, :precision => 2)
            number_with_precision(user.donated, :precision => 2)
        end
        actions defaults: false do |user|
          button_to('Edit', edit_admin_volunteer_path(user), class: "purple", style:"font-size:0.8em;padding:5px 10px") +
          button_to('Delete', admin_volunteer_path(user), data: { confirm: "Are you sure?" }, method: :delete, class: "red", style:"font-size:0.8em;padding:5px 10px")
        end
    end
    
    filter :name
    filter :email, as: :string
    filter :interests, collection: proc { Interest.all }
    filter :donated, as: :range_select
    
    form do |f| 
        f.inputs do
            f.input :name, input_html: { required: true }
            if f.object.new_record?
                f.input :password
                f.input :password_confirmation
            end
            f.input :email, required: true
            f.input :home_phone
            f.input :dob, as: :date_select, :start_year => 1900, :end_year => Date.current.year, :use_month_numbers => true, :order => [:year, :month, :day]
            f.input :interests, as: :check_boxes
            f.input :other_interests, as: :string
        end
        f.actions
        para "Press cancel to return to the list without saving."
    end
    
    controller do
        def update
            super
            if params[:user][:other_interests] then
                @int_params = params[:user][:other_interests].split(',')
                @int_params.each do |int|
                    int = int.strip.downcase.capitalize
                    if !(Interest.find_by name: int)
                        Interest.create!(name: int)
                    end
                    (User.find_by id: params[:id]).interests << (Interest.find_by name: int)
                end
            end
        end
        def create
            super
            if params[:user][:other_interests] then
                @int_params = params[:user][:other_interests].split(',')
                @int_params.each do |int|
                    int = int.strip.downcase.capitalize
                    if !(Interest.find_by name: int)
                        Interest.create!(name: int)
                    end
                    (User.find_by id: params[:id]).interests << (Interest.find_by name: int)
                end
            end
        end
    end
    
    show do
        attributes_table title: "Profile" do
          row :name
          row :email
          row :phone
          row :dob
          row "Interests" do |user|
            user.interests.map(&:name).join(", ")
          end
          row :bio
          row :avatar_file_name
          row :avatar_file_size do |user|
              (user.avatar_file_size.to_f / 1024).ceil.to_s + " KB"  # Convert from bytes to kilobytes
          end
        end
        attributes_table title: "More Details" do
          row :created_at
          row :updated_at
          row :sign_in_count
          row :current_sign_in_at
          row :current_sign_in_ip
          row :last_sign_in_at
          row :last_sign_in_ip
          row :confirmed_at
          row :confirmation_token
          row :confirmation_sent_at
          row :unconfirmed_email
          row :reset_password_token
          row :reset_password_sent_at
        end
    end
end