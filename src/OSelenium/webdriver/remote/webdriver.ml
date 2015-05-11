module MyDict = Map.Make(String)

exception WebDriverException of string
exception KeyError of string
(** Controls a browser by sending commands to a remote server.  This
server is expected to be running the WebDriver wire protocol as
defined at
https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol
Attributes:
- [session_id] : String ID of the browser session started and
  controlled by this WebDriver.
- [capabilities] : Dictionary of effective capabilities of this
  browser session as returned by the remote server. See
  https://github.com/SeleniumHQ/selenium/wiki/DesiredCapabilities
- [command_executor] : remote_connection.RemoteConnection object used to
execute commands.
- [error_handler] : errorhandler.ErrorHandler object used to handle errors.
 *)
class webdriver ?(command_executor="http://127.0.0.1:4444/wd/hub") ?browser_profile ?proxy ?(keep_alive=true) ~desiredcapabilities =
object(self)
  val m_command_executor = Remote command_executor
  val mutable m_is_remote = true
  val mutable m_session_id = None
  val mutable m_capabilities = MyDict.empty
  val m_error_handler = new ErrorHandler.ErrorHandler ()
  val m_switch_to = new SwitchTo.SwitchTo self
  val m_mobile = new Mobile.Mobile self
  val m_file_detector = new FileDetector.LocalFileDetector

  method mobile () = m_mobile

  (** Returns the name of the underlying browser for this instance.
        :Usage:
         - driver#name () *)
  method name () =
    try
      MyDict.find "browserName" m_capabilities
    with Not_found ->
      raise (KeyError "browserName not specified in session capabilities")

  (** Called before starting a new session. This method may be overridden
      to define custom startup behavior. *)
  method start_client () =
    ()

  (** Called after executing a quit command. This method may be overridden
      to define custom shutdown behavior.*)
  method stop_client () =
    ()

  (** Creates a new session with the desired capabilities.
      :Args:
      - [browser_name] : The name of the browser to request.
      - [version] : Which browser version to request.
      - [platform] : Which platform to request the browser on.
      - [javascript_enabled] : Whether the new session should support
          JavaScript.
      - [browser_profile] : A selenium.webdriver.firefox.firefox_profile.FirefoxProfile object. Only used if Firefox is requested. *)
  method start_session ?browser_profile desiredcapabilities =
    (* TODO *)

    
  initializer
    CCOpt.iter proxy#add_to_capabilities desired_capabilities;
    self#start_client ();
    self#start_session(desired_capabilities, browser_profile)
	
end;;
