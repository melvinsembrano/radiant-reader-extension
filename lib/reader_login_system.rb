module ReaderLoginSystem

  def self.included(base)
    base.class_eval %{
      helper_method :current_reader
      before_filter :set_current_reader
      alias_method_chain :login_from_cookie, :readers
      alias_method_chain :set_session_cookie, :readers
    } 
    super
  end

  protected
    
    def current_reader
      @current_reader ||= Reader.find(session['reader_id']) rescue nil
    end
    
    def current_reader=(value=nil)
      if value && value.is_a?(Reader)
        @current_reader = value
        session['reader_id'] = value.id 
      else
        @current_reader = nil
        session['reader_id'] = nil
      end
      @current_reader
    end
    
    # it is quite possible to be logged in both as user and reader
    # they may differ or overlap in their priveleges
    # or it may be useful for an admin to masquerade as a reader to review pages

    def login_from_cookie_with_readers
      if !cookies[:reader_session_token].blank? && reader = Reader.find_by_session_token(cookies[:reader_session_token]) # don't find by empty value
        reader.remember_me
        self.current_reader = reader
        set_session_cookie
      end
      login_from_cookie_without_readers
    end
    
    def set_session_cookie_with_readers
      set_reader_cookie if current_reader
      set_session_cookie_without_readers if current_user
    end
    
    def set_reader_cookie
      cookies[:reader_session_token] = { :value => current_reader.session_token , :expires => Radiant::Config['session_timeout'].to_i.from_now.utc }
    end
    
  private

    def set_current_reader

    end

end





