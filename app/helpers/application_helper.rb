module ApplicationHelper
  def edit_and_destroy_buttons(item)
    unless current_user.nil?
      edit = link_to('Edit', url_for([:edit, item]), class: "btn btn-warning")
      del = link_to('Destroy', item, method: :delete,
                                     data: { confirm: 'Are you sure?' },
                                     class: "btn btn-danger") unless current_user.admin != true

      raw("#{edit} #{del}")
    end
  end
end
