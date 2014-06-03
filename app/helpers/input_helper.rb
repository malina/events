module InputHelper
  def search_field(val = 'keyword', placeholder ='', options = {})
    merge_class! options,'search-field text-input-wrap'
    content_tag(:div, nil, options) do
      concat text_field(val,nil,class: 'text-input', placeholder: placeholder)
      concat fa_icon('times')
    end
  end

  def text_input(name = nil, placeholder ='', klass ='', options = {})
    merge_class! options, 'text-input-wrap '+ klass
    content_tag(:div, nil, options) do
      concat text_field_tag(name, nil,  class: 'text-input '+(klass.blank? ? '' : klass+'-input'), placeholder: placeholder)
    end
  end

  def pass_input(name = nil, placeholder ='', klass ='', options = {})
    merge_class! options, 'text-input-wrap '+ klass
    content_tag(:div, nil, options) do
      concat password_field_tag(name, nil,  class: 'text-input '+(klass.blank? ? '' : klass+'-input'), placeholder: placeholder)
    end
  end

  def text_area(name = nil, placeholder ='', klass ='', options = {})
    merge_class! options, 'text-input-wrap '+ klass
    content_tag(:div, nil, options) do
      concat text_area_tag(name, nil,  class: 'text-input '+(klass.blank? ? '' : klass+'-input'), placeholder: placeholder)
    end
  end

  def check_box(name = nil, val = nil, label = '', options = {})
    merge_class! options,'checkbox-wrap'
    merge_data!(options,{:component => 'check_box'})
    content_tag(:div, nil, options) do
      concat hidden_field_tag(name, val, class: 'checkbox-input')
      concat check_box_label(label, name)
    end
  end

  def check_box_label(label, name = nil, options = {}) 
    merge_class! options,'checkbox-wrap'
    label_tag(name, nil, class: 'cb-label') do
      concat fa_icon('square-o')
      concat fa_icon('check-square-o')
      concat label
    end
  end

  def sort_button(tag,label,options = {})
    merge_class! options,'sort-button'
    merge_data!(options,{:component => 'sort_button'})
    content_tag(tag, nil, options) do 
        concat label
        concat fa_icon('sort-desc')
        concat fa_icon('sort-asc')
    end
  end

  protected
    def merge_class!(options,klass)
      options[:class] = (options[:class] ? "#{options[:class]} " : '') << klass
    end

    def merge_data!(options,data)
      options[:data] = (options[:data] ? options[:data] : {}).merge(data)
    end
end