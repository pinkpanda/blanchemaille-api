helpers do
  def permit(params, model)
    params.extract!(*model.column_names.map(&:to_sym))
  end
end
