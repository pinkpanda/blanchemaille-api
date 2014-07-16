helpers do
  def json_body_params
    return begin
      MultiJson.load request.body.read.to_s, symbolize_keys: true
    rescue MultiJson::LoadError
      {}
    end
  end

  def permit(params, model)
    params.with_indifferent_access.extract!(*model.column_names.map(&:to_sym))
  end
end
