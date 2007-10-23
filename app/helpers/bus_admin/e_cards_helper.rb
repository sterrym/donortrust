module BusAdmin::ECardsHelper
  
  def file_form_column(record, input_name)
    file_column_field 'record', :small
  end

  def file_column(record)
    record.file ?  link_to(File.basename(record.file), url_for_file_column(record, 'file'), :popup => true) : "-" 
  end
end