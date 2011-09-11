<cfsilent>
<!--- EDITABLE CONFIG SETTINGS ON LINE 322 --->
<!---
filename:			tags/forms/form.cfm
date created:	10/22/07
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:			I display an XHTML 1.0 Strict form based upon the Uni-Form markup

	// **************************************** LICENSE INFO **************************************** \\

	Copyright 2007, Matt Quackenbush

	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in
	compliance with the License.  You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software distributed under the License is
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
	implied.  See the License for the specific language governing permissions and limitations under the
	License.

	// ****************************************** REVISIONS ****************************************** \\

	DATE		DESCRIPTION OF CHANGES MADE												CHANGES MADE BY
	===================================================================================================
	10/22/07		New																				MQ

	6/1/08			Added support for auto-loading of CSS/JS prerequisites.							MQ
					Added support for jQuery's masked-input plugin.
					Added support for jQuery's datepicker plugin - enhancement submitted by Dan Wilson.
					Added support for jQuery's timeentry plugin - enhancement submitted by Dan Wilson.

	7/15/08			Added support for optional error message placement								MQ

	9/22/08			Added support for jQuery's PrettyComments plugin					Bob Silverberg
						 (textarea resizing)

	9/29/08			Added support for loading plugin setups for jQuery's 							MQ
						 datepicker, timeentry, and validation plugins

	11/12/08		Added support for passing in a struct of field labels,				Bob Silverberg
						in support of integration with ValidateThis!.
						http://validatethis.riaforge.org/
						http://www.silverwareconsulting.com/index.cfm/ValidateThis

	11/12/08		Added support for plugin setups to be passed in via the config  				MQ
						 attribute - enhancement submitted by Dan Wilson

	12/11/08		Added support for the second submit button to be floated left.  				MQ
						 Useful for having a "Back" button in a wizard application.

	1/15/09			Bug fix: IE has an issue with enctype on an empty form, so the   				MQ
						 enctype is now dynamically set.

	2/19/09			Complete v3.0 update.  Updated paths to css/script files.  Added 				MQ
						 new uniformCSSie config argument since the new Uni-Form
						 markup/CSS requires IE-specific rules.  Added new okMsg
						 attribute for supplying a success message.  Updated to latest
						 jQuery, validation plugin, masked input plugin, time entry
						 plugin releases.

	2/26/09			Bug fix: When validation rules were added via the validationSetup				MQ
						 attribute, clicking the cancel button would still cause
						 validation routines to run.  The cancel button now bypasses
						 validation.

	2/26/09			Added the 'cancelAction' attribute, which supports a client-side 				MQ
						 javascript redirect to the URL provided to this attribute.

	1/13/10			Added the optional 'enctype' attribute, which allows the user to				MQ
						 provide "multipart/form-data" for use cases where they are
						 using a file field within a type="custom" field that would
						 otherwise go unnoticed.  Thanks to Byron Raines for providing
						 the use case.

	2/15/10			Added the optional 'loadDefaultCSS' attribute, which allows the user			MQ
						 to tell cfUniForm *not* to load anything for use cases where
						 they have already loaded the Uni-Form CSS themselves.

	2/15/10			Added the optional 'loadDefaultJS' attribute, which allows the user				MQ
						 to tell cfUniForm *not* to load anything for use cases where
						 they have already loaded the Uni-Form JS themselves.

	2/15/10			Added the optional 'addJStoHead' attribute, which allows the user				MQ
						 to tell cfUniForm to load the JS into the head.  If false,
						 it will be loaded immediately after the form markup.
						 Defaults to 'true'.

	2/15/10			Added the optional 'jsConfigVar' attribute, which allows the user				MQ
						 to tell cfUniForm to return the jsConfig to the caller.

	2/15/10			Added the optional 'configForm' attribute, which allows the user				MQ
						 to tell cfUniForm to call jQuery().uniform() on this specific
						 form.

	2/21/10			Updated to latest versions of validation, datepick and timeEntry plugins.		MQ

	2/21/10			Changed behavior of date/time setups so that there are now 3 config levels:		MQ
						 	global [via 'config' attribute on form tag]
						 	form [via 'date|timeSetup' attributes on form tag]
						 	field [via 'pluginSetup' attribute on field tag]
						 A *huge* Thank You! to Byron Raines for his time and code
						 contributions on these updates!

	2/23/10			Added support for jQuery's star-ratings plugin, which includes					MQ
						the following new attributes:
							loadRatingUI
							configRatingUI

	2/23/10			Changed the required data type and behavior of the following attributes:		MQ
							dateSetup
							timeSetup
							validationSetup
							textareaSetup
						Each attribute now accepts either a string OR a struct.  For
						more information, see the comments in the use example section.

	2/23/10			Added the 'pathConfig' attribute.  This is a replacement for the				MQ
						old 'config' attribute, which was poorly named.  Please use
						this attribute on all new forms and update old forms to use
						it as well.

	2/23/10			Deprecated the 'config' attribute.  Use 'pathConfig' instead.					MQ

	4/09/10			Added the 'jsLoadVar' and 'cssLoadVar' attributes.  These attributes			MQ
						facilitate returning the CSS and JS load strings to the caller.
						See use example comments for details.

	6/25/10			Added 'uniformThemeCSS' to config settings, for use with the new				MQ
						Uni-Form 1.4 theme-based CSS.

	6/26/10			Updated some defaults for use with the new Uni-Form 1.4 theme-based CSS.		MQ
						- changed the 'uniformCSS' attribute value
						- changed the 'errorListType' attribute value

	7/12/10			Added integration support for ValidateThis (http://www.validatethis.org/).		MQ
						added the 'VT', 'VTcontext', 'VTtarget', and 'VTlocale' attributes

	12/16/10		Changed from using $ as a reference to jQuery to using 'jQuery' to support		MQ
						configurations where the user is using jQuery.noConflict().

	12/16/10		Removed support for the config attribute (deprecated 2/10 in v4.0).				MQ

	3/2/11			Added 'class' attribute for placing additional class(es) on form.				MQ

 --->

<!--- // use example

	// REQUIRED ATTRIBUTES
	@action					Required (string)		The path to be supplied to the action="" attribute of the form tag
	@id							Required (string)		The form ID (goes into the id="" attribute of the form tag)

	// OPTIONAL ATTRIBUTES
	@loadDefaultCSS		Optional (boolean)	Indicates whether or not to load the Uni-Form CSS files.
																			Defaults to true.
	@loadDefaultJS		Optional (boolean)	Indicates whether or not to load the Uni-Form JS files.
																			Defaults to true.
	@loadDateUI			Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery UI datepicker plugin.
																			Defaults to false.
	@configDateUI		Optional (boolean)	Indicates whether or not to run configuration routines for the jQuery UI datepicker plugin.
																			Defaults to false.
	@dateSetup			Optional (any)		Commands to load for the jQuery datepick plugin. Can be provided as
												a string OR a struct.  If it is a string, it will be loaded as-is.
												If it is a struct, it will be looped over and a string of key-value
												pairs will be created.

												Defaults to an empty string.
	@loadTimeUI			Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery time entry plugin.
																			Defaults to false.
	@configTimeUI		Optional (boolean)	Indicates whether or not to run configuration routines for the jQuery time entry plugin.
																			Defaults to false.
	@timeSetup			Optional (any)		Commands to load for the jQuery time entry plugin. Can be provided as
												a string OR a struct.  If it is a string, it will be loaded as-is.
												If it is a struct, it will be looped over and a string of key-value
												pairs will be created.

												Defaults to an empty string.
	@loadMaskUI			Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery masked input plugin.
																			Defaults to false.
	@configMaskUI		Optional (boolean)	Indicates whether or not to run configuration routines for the jQuery masked input plugin.
																			Defaults to false.
	@loadValidation		Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery form validation plugin.
																			Defaults to false.
	@configValidation	Optional (boolean)	Indicates whether or not to run configuration routines for the jQuery form validation plugin.
																			Defaults to false.
	@validationSetup	Optional (any)		Commands to load for the jQuery validation plugin. Can be provided as
												a string OR a struct.  If it is a string, it will be loaded as-is.
												If it is a struct, it will be looped over and a string of key-value
												pairs will be created.

												Defaults to an empty string.
	@loadRatingUI		Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery star-ratings plugin.
																			Defaults to false.
	@configRatingUI		Optional (boolean)	Indicates whether or not to run configuration routines for the jQuery star-ratings plugin.
																			Defaults to false.
	@loadjQuery			Optional (boolean)	Indicates whether or not to load the jQuery core library.
																			Defaults to false.
	@loadTextareaResize		Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery Elastic plugin.
																			Defaults to false.
	@errors				Optional (struct|array)	A struct or an array of validation error messages to display.
													If passing a struct, each key should match a field name
													on the form, with its value being the error message.
														e.g. myErrors = structNew();
															 myErrors.userName = "The User Name is invalid.";

													If passing an array, each index of the array *must*
													contain a struct with two keys:

														1) property
														2) message

													The 'property' key should match the offending field name on the form.
													The 'message' key is the error message that will be displayed.
														e.g. myErrors = arrayNew(1);
															 struct = structNew();
															 struct.property = "UserName";
															 struct.message = "The User Name is invalid.";
															 arrayAppend(myErrors, struct);

													An exception will be thrown if the array does not
													meet the above specification.
	@errorTitle			Optional (string)		The title to display above the error messages. Defaults to:
																			"Ooooops!  Invalid Fields!"
	@errorMessage		Optional (string)		The message to display above the error messages. Defaults to:
																			"The following errors were detected in your form.
																			 Please fix the offending fields and re-submit."
	@errorMessagePlacement	Optional (string)	Indicates where to display the error messages (if any).  Valid options are:
																			top
																			inline
																			both (default)
																			none

	@errorMessageInlinePlacement Optional (string) Indicates whether to display the error message above the form field or below it. UniForm spec is "top". Valid options are:
																			top (default)
																			bottom

	@errorListType		Optional (string)		The type of (HTML) list to use in displaying validation errors.
																			Acceptable values are:
																				ol
																				ul
																			Defaults to 'ul'.
	@method					Optional (string)		The form method; either 'post' or 'get'.  Defaults to 'post'.
	@class					Optional (string)		Additional class(es) to add to the form's class attribute.  Defaults to an empty string.
	@showCancel			Optional (boolean)	Indicates whether or not to show a 'Cancel' button.
																			Defaults to true.
	@cancelValue			Optional (string)		The text to show on the 'Cancel' button.  Defaults to ' Cancel '.
	@cancelAction			Optional (string)		The URL that JavaScript will direct the browser to if the 'Cancel' button is clicked.
														Can be a full URL (e.g. 'http://www.domain.com/index.cfm') or a file (e.g. 'index.cfm').
														If not provided, or is an empty string, the form will be submitted normally.
															Defaults to an empty string.
	@cancelName				Optional (string)		The name and id for the cancel button. Defaults to "cancelButton"
	@submitValue			Optional (string)		The text to show on the 'Submit' button.  Defaults to ' Submit '.
	@submitName				Optional (string) 		Name for the submit button. Defaults to "submitButton"
	@showReset			Optional (boolean)	Indicates whether or not to show a 'Reset' button.
																			Defaults to false.
	@resetValue			Optional (string)		The text to show on the 'Reset' button.  Defaults to ' Reset '.
	@submit2name			Optional (string)		The name/id of a second submit button.  If not provided (or if an empty string is provided),
															a second submit button will *not* be displayed.
	@submit2value			Optional (string)		The text to show on the second submit button.
	@submit2placement			Optional (string)	Indicates whether the second submit button should appear on the far left,
														immediately before or immediately after the standard one.
														Valid values are:
																before
																after
																left
														Defaults to 'before'.
	@isDisabled			Optional (boolean)			Whether to set the entire form to disabled. Defaults to false

	@addJStoHead		Optional (boolean)			Indicates whether or not cfUniForm should add the JS to the <head> of the document.
														If 'false', it will be added immediately after the form markup.
														Defaults to 'true'.
	@jsConfigVar		Optional (string)			The name of the variable that should be used to return the jsConfig to the caller.
														If not provided, the jsConfig will be added automatically. (Default behavior.)
														If provided, cfUniForm will set the variable in the calling page.
	@jsLoadVar			Optional (string)			The name of the variable that should be used to return the JavaScript load HTML to the caller.
														(e.g. all of the <script src="/path/to/script.js"></script> load strings)

														If provided, cfUniForm will set the variable in the calling page.

														NOTE: Providing this variable will completely override @addJStoHead.  That is, @addJStoHead
														*will* be ignored.
	@cssLoadVar			Optional (string)			The name of the variable that should be used to return the CSS load HTML to the caller.
														(e.g. all of the <link rel="stylesheet" src="/path/to/styles.css" /> load strings)

														If provided, cfUniForm will set the variable in the calling page rather than adding them
														to the document <head>.
	@configForm			Optional (boolean)			Indicates whether or not cfUniForm should call jQuery().uniform() on this specific form.
														Useful if you have all of the assets already loaded and are loading the form
														into the page via ajax.
														Defaults to 'false'.
	@VT					Optional (any)				If you want to use VT in conjunction with your cfUniForm-powered form, provide the ValidateThis
														object to this attribute (e.g. VT="#application.ValidateThis#").

														Defaults to an empty string.
	@VTtarget			Optional (any)				If you want to use VT in conjunction with your cfUniForm-powered form, provide the target object
														to this attribute; that is, the object that VT should be validating (e.g. VTtarget="#myObject#").

														Defaults to an empty string.
	@VTcontext			Optional (string)			If you want to use VT in conjunction with your cfUniForm-powered form, provide the validation context
														to this attribute (e.g. VTcontet="Registration").

														Defaults to an empty string.
	@VTlocale			Optional (string)			If you want to use VT in conjunction with your cfUniForm-powered form, provide the locale
														to this attribute (e.g. VTcontet="EN").

														Defaults to an empty string.
	@pathConfig			Optinoal (struct)			Used to provide path configuration for the various integrated CSS and JS libraries.
														Defaults to #structNew()#

    @commonassetsPath	Optional (string)			Rather than having to specify every asset via @pathConfig, if you've just moved all the assets en masse
    												You can just specify the commonassetsPath instead. Defaults to /commonassets/

	@config				DEPRECATED in v4.0			DEPRECATED.  Use 'pathConfig' instead.

	// STEPS TO USE THIS TAG

		Step 1: load the uform tags

			<cfimport taglib="/tags/forms/cfUniForm" prefix="uform" />

		Step 2: open the form

			<uform:form action="myAction.cfm" method="post" id="myForm">

		Step 3: add the form elements

			for more info on Step 3, see the "use example" comments in the following tags:
				- fieldset.cfm
				- field.cfm
				- option.cfm
				- checkbox.cfm
				- radio.cfm
				- countryCodes.cfm
				- states-us.cfm
				- states-can.cfm

		Step 4: close the form

			</uform:form>

	// SIMPLE EXAMPLE

		<cfimport taglib="/tags/forms/cfUniForm" prefix="uform" /> <-------- Step 1
		<uform:form action="myAction.cfm" method="post" id="myForm"> <------- Step 2
			<uform:fieldset legend="Required Fields" class="inlineLabels"> <--------- Step 3 (NOTE: next four lines are part of this step)
				<uform:field label="Email Address" name="emailAddress" isRequired="true" type="text" value="" hint="Note: Your email is your username.  Use a valid email address."  />
				<uform:field label="Choose Password" name="password" isRequired="true" type="password" value=""  />
				<uform:field label="Re-enter Password" name="password2" isRequired="true" type="password" value=""  />
			</uform:fieldset>
		</uform:form> <--------------------------------------------------------------------- Step 4

 --->

<!--- config settings --->
<cfscript>
	_config = structNew();
	_config.jQuery = "https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js";
	_config.jqui = "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.7/jquery-ui.min.js";
	_config.jquiCSS = "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.7/themes/smoothness/jquery-ui.css";
	_config.renderer = "../renderValidationErrors.cfm";
	_config.uniformCSS = "/commonassets/css/uni-form.css";
	_config.uniformCSSie = "/commonassets/css/uni-form-ie.css";
	_config.uniformThemeCSS = "/commonassets/css/uni-form.default.css";
	_config.uniformJS = "/commonassets/scripts/jQuery/forms/uni-form.jquery.js";
	_config.validationJS = "http://ajax.microsoft.com/ajax/jquery.validate/1.7/jquery.validate.min.js";
	_config.inputJS = "/commonassets/scripts/jQuery/forms/jquery.field-0.9.3.min.js";
	_config.dateCSS = "/commonassets/css/datepick/jquery.datepick.css";
	_config.dateJS = "/commonassets/scripts/jQuery/forms/jquery.datepick-3.7.5.min.js";
	_config.timeCSS = "/commonassets/css/jquery.timeentry.css";
	_config.timeJS = "/commonassets/scripts/jQuery/forms/jquery.timeentry-1.4.6.min.js";
	_config.jquiTimeJS = "/commonassets/scripts/jQuery/forms/jquery.timepicker.addon-0.9.1.min.js";
	_config.maskJS = "/commonassets/scripts/jQuery/forms/jquery.maskedinput-1.2.2.min.js";
	_config.textareaJS = "/commonassets/scripts/jQuery/forms/jquery.elastic-1.6.10.min.js";
	_config.ratingCSS = "/commonassets/css/jquery.rating.css";
	_config.ratingJS = "/commonassets/scripts/jQuery/forms/jquery.rating-3.12.min.js";
</cfscript>

<!--- SHOULD BE NO NEED TO EDIT BELOW THIS LINE --->
<!--- define the tag attributes --->
	<!--- required attributes --->
	<cfparam name="attributes.action" type="string" />
	<cfparam name="attributes.id" type="string" />

	<!--- optional attributes --->
	<cfparam name="attributes.loadDefaultCSS" type="boolean" default="yes" />
	<cfparam name="attributes.loadDefaultJS" type="boolean" default="yes" />
	<cfparam name="attributes.loadDateUI" type="boolean" default="no" />
	<cfparam name="attributes.configDateUI" type="boolean" default="#attributes.loadDateUI#" />
	<cfparam name="attributes.loadTimeUI" type="boolean" default="no" />
	<cfparam name="attributes.configTimeUI" type="boolean" default="#attributes.loadTimeUI#" />
	<cfparam name="attributes.configTimestampUI" type="boolean" default="no" />
	<cfparam name="attributes.loadMaskUI" type="boolean" default="no" />
	<cfparam name="attributes.configMaskUI" type="boolean" default="#attributes.loadMaskUI#" />
	<cfparam name="attributes.loadValidation" type="boolean" default="no" />
	<cfparam name="attributes.configValidation" type="boolean" default="#attributes.loadValidation#" />
	<cfparam name="attributes.loadRatingUI" type="boolean" default="no" />
	<cfparam name="attributes.configRatingUI" type="boolean" default="#attributes.loadRatingUI#" />
	<cfparam name="attributes.loadjQuery" type="boolean" default="no" />
	<cfparam name="attributes.loadjQueryUI" type="boolean" default="no" />
	<cfparam name="attributes.loadjQueryUICSS" type="boolean" default="#attributes.loadjQueryUI#" />
	<cfparam name="attributes.usejQueryUI" type="boolean" default="no" />
	<cfparam name="attributes.loadTextareaResize" type="boolean" default="no" />
	<cfparam name="attributes.dateSetup" type="any" default="" />
	<cfparam name="attributes.timeSetup" type="any" default="" />
	<cfparam name="attributes.validationSetup" type="any" default="" />
	<cfparam name="attributes.errors" type="any" default="#structNew()#" />
	<cfparam name="attributes.errorTitle" type="string" default="Oooops!  Invalid Fields!" />
	<cfparam name="attributes.errorMessage" type="string" default="The following errors were detected in your form.  Please fix the offending fields and re-submit." />
	<cfparam name="attributes.errorMessagePlacement" type="string" default="both" />
	<cfparam name="attributes.errorMessageInlinePlacement" type="string" default="top" />
	<cfparam name="attributes.errorListType" type="string" default="ol" />
	<cfparam name="attributes.okMsg" type="string" default="" />
	<cfparam name="attributes.method" type="string" default="post" />
	<cfparam name="attributes.class" type="string" default="" />
	<cfparam name="attributes.showSubmit" type="boolean" default="yes" />
	<cfparam name="attributes.showCancel" type="boolean" default="no" />
	<cfparam name="attributes.cancelValue" type="string" default=" Cancel " />
	<cfparam name="attributes.cancelAction" type="string" default="" />
	<cfparam name="attributes.cancelName" type="string" default="cancelButton" />
	<cfparam name="attributes.submitValue" type="string" default=" Submit " />
	<cfparam name="attributes.submitName" type="string" default="submitButton" />
	<cfparam name="attributes.showReset" type="boolean" default="no" />
	<cfparam name="attributes.resetValue" type="string" default=" Reset " />
	<cfparam name="attributes.submitButtonAddClass" type="string" default="" />
	<cfparam name="attributes.submit2name" type="string" default="" />
	<cfparam name="attributes.submit2value" type="string" default="" />
	<cfparam name="attributes.submit2placement" type="string" default="before" />
	<cfparam name="attributes.configForm" type="boolean" default="no" />
	<cfparam name="attributes.addJStoHead" type="boolean" default="yes" />
	<cfparam name="attributes.jsConfigVar" type="string" default="" />
	<cfparam name="attributes.jsLoadVar" type="string" default="" />
	<cfparam name="attributes.cssLoadVar" type="string" default="" />
	<cfparam name="attributes.enctype" type="string" default="application/x-www-form-urlencoded" />
	<cfparam name="attributes.requiredFields" type="struct" default="#structNew()#" />
	<cfparam name="attributes.fieldLabels" type="struct" default="#structNew()#" />
	<cfparam name="attributes.VT" type="any" default="" />
	<cfparam name="attributes.VTcontext" type="any" default="" />
	<cfparam name="attributes.VTtarget" type="any" default="" />
	<cfparam name="attributes.VTlocale" type="any" default="" />
	<cfparam name="attributes.pathConfig" type="struct" default="#structNew()#" />
	<cfparam name="attributes.commonassetsPath" type="string" default="/commonassets/" />
	<cfparam name="attributes.config" type="struct" default="#structNew()#" /><!--- deprecated in v4.0 (2/23/10) - MQ --->

	<cfparam name="attributes.isDisabled" type="boolean" default="false" />

<!--- config settings --->
<cfscript>
	_config = structNew();
	_config.jQuery = "https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js";
	_config.jqui = "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.7/jquery-ui.min.js";
	_config.jquiCSS = "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.7/themes/smoothness/jquery-ui.css";
	_config.renderer = "../renderValidationErrors.cfm";
	_config.uniformCSS = "#attributes.commonassetsPath#css/uni-form.css";
	_config.uniformCSSie = "#attributes.commonassetsPath#css/uni-form-ie.css";
	_config.uniformThemeCSS = "#attributes.commonassetsPath#css/uni-form.default.css";
	_config.uniformJS = "#attributes.commonassetsPath#scripts/jQuery/forms/uni-form.jquery.js";
	_config.validationJS = "http://ajax.microsoft.com/ajax/jquery.validate/1.7/jquery.validate.min.js";
	_config.inputJS = "#attributes.commonassetsPath#scripts/jQuery/forms/jquery.field-0.9.3.min.js";
	_config.dateCSS = "#attributes.commonassetsPath#css/datepick/jquery.datepick.css";
	_config.dateJS = "#attributes.commonassetsPath#scripts/jQuery/forms/jquery.datepick-3.7.5.min.js";
	_config.timeCSS = "#attributes.commonassetsPath#css/jquery.timeentry.css";
	_config.timeJS = "#attributes.commonassetsPath#scripts/jQuery/forms/jquery.timeentry-1.4.6.min.js";
	_config.jquiTimeJS = "#attributes.commonassetsPath#scripts/jQuery/forms/jquery.timepicker.addon-0.9.1.min.js";
	_config.maskJS = "#attributes.commonassetsPath#scripts/jQuery/forms/jquery.maskedinput-1.2.2.min.js";
	_config.textareaJS = "#attributes.commonassetsPath#scripts/jQuery/forms/jquery.elastic-1.6.10.min.js";
	_config.ratingCSS = "#attributes.commonassetsPath#css/jquery.rating.css";
	_config.ratingJS = "#attributes.commonassetsPath#scripts/jQuery/forms/jquery.rating-3.12.min.js";
</cfscript>


<!--- make sure we have either a struct or an array of errors --->
<cfif NOT isArray(attributes.errors) AND NOT isStruct(attributes.errors)>
	<cfthrow errorcode="tags.forms.cfUniForm.form.invalidErrorPlacement"
			message="The 'errors' attribute *must* be either an array or a struct." />
</cfif>

<cfif listFindNoCase("top,inline,both,none", attributes.errorMessagePlacement) EQ 0>
	<cfthrow errorcode="tags.forms.cfUniForm.form.invalidErrorPlacement"
			message="Only the following are valid values for the 'errorMessagePlacement' argument: top,inline,both,none." />
</cfif>

<cfscript>
	err = attributes.errors;
	listType = lCase(attributes.errorListType);
	if ( NOT listFind("ul,ol", listType) ) { listType = "ul"; }
	jsConfig = "";
	_vtConfig = "";
	_js = "";
	_jQ = "";
	_jqui = "";
	_stdCSS = "";
	_jquiCSS = "";
	_stdJS = "";
	_validJS = "";
	_dateCSS = "";
	_dateJS = "";
	_timeCSS = "";
	_timeJS = "";
	_maskJS = "";
	_textareaJS = "";
	_ratingCSS = "";
	_ratingJS = "";
	// merge the default _config with the attributes.pathConfig struct
	structAppend(_config,attributes.pathConfig,true);
</cfscript>

<!--- convert plugin config structs to strings --->
<cffunction name="buildConfigString" access="private" output="false" returntype="string">
	<cfargument name="value" required="yes" type="struct" />
	<cfscript>
		var rtn = "";
		var key = "";
		// loop through the struct and build the setup
		for ( key IN arguments.value ) {
			if ( len(rtn) GT 0 ) {
				rtn = rtn & ", ";
			}
			rtn = rtn & key & ":" & arguments.value[key];
		}
		return "{" & rtn & "}";
	</cfscript>
</cffunction>

<!--- create the datesetup string --->
<cffunction name="getDateSetup" access="private" output="false" returntype="string">
	<cfscript>
		var rtn = "";
		if ( isSimpleValue(attributes.dateSetup) AND len(trim(attributes.dateSetup)) GT 0 )
		{
			rtn = attributes.dateSetup;
		}
		else if ( isStruct(attributes.dateSetup)
						AND
							structCount(attributes.dateSetup) GT 0 )
		{
			rtn = buildConfigString(attributes.dateSetup);
		}
		return rtn;
    </cfscript>
</cffunction>
<!--- create the timesetup string --->
<cffunction name="getTimeSetup" access="private" output="false" returntype="string">
	<cfscript>
		var rtn = "";
		if ( isSimpleValue(attributes.timeSetup) AND len(trim(attributes.timeSetup)) GT 0 )
		{
			rtn = attributes.timeSetup;
		}
		else if ( isStruct(attributes.timeSetup)
						AND
							structCount(attributes.timeSetup) GT 0 )
		{
			rtn = buildConfigString(attributes.timeSetup);
		}
		return rtn;
    </cfscript>
</cffunction>

<!--- handle validation cancelation if we have a cancel button --->
<cfif attributes.showCancel>
	<cfsavecontent variable="jsConfig">
	<cfoutput>
	jQuery("###attributes.id# button[name='#attributes.cancelName#']").click(function(){
	<cfif attributes.loadValidation OR attributes.configValidation>
		var input = jQuery("###attributes.id# :input");
		input.each(function(i,el){
			jQuery(el).rules("remove");
		});
		jQuery("###attributes.id# :input").removeClass("required").addClass("ignore");
		jQuery("###attributes.id#").validate({ignore: ".ignore"});
	</cfif>
		<cfif len(attributes.cancelAction) GT 0>window.location.href="#attributes.cancelAction#"; return false;</cfif>
	});
	</cfoutput>
	</cfsavecontent>
	<!---
		Whitespace used above for readability.  Strip it out for rendering to save bandwidth.
	 --->
	<cfset reReplace(jsConfig,"[\s]{2,}"," ","all") />
</cfif>
<!--- // this will disable buttons after submit, but need to play with the validation plugin so that it only happens after successful validation
jQuery("button.submitButton").click(function() { jQuery(this).attr("disabled",true).html("Processing, please wait..."); jQuery("button").attr("disabled",true); });
 --->
</cfsilent>
<cfsetting enablecfoutputonly="yes" />
<!--- BEGIN: executionMode check --->
<cfif thisTag.executionMode IS "end">
	<cfscript>
		__generatedContent = thisTag.generatedContent;
		thisTag.generatedContent = "";
	</cfscript>

	<!--- make sure we have a fieldsets array --->
	<cfparam name="thisTag.fieldsets" default="#arrayNew(1)#" />

	<cfscript>
		_enctype = attributes.enctype;

		if ( _enctype IS "application/x-www-form-urlencoded" ) {
			for ( i=1; i LTE arrayLen(thisTag.fieldsets); i=i+1 ) {
				if ( thisTag.fieldsets[i].hasUpload ) {
					_enctype = "multipart/form-data";
					break;
				}
			}
		}
	</cfscript>

	<!--- the tag execution is beginning, so open the form and display any validation error messages that exist --->
	<cfoutput><!-- rendered by cfUniForm v4.6.0 (http://www.quackfuzed.com/demos/cfUniForm/) --><form action="#attributes.action#" method="#attributes.method#" enctype="#_enctype#" id="#attributes.id#" class="uniForm #attributes.class#"></cfoutput>
	<!--- BEGIN: validation error check --->
	<cfif ((isStruct(err) AND structCount(err) GT 0) OR (isArray(err) AND arrayLen(err) GT 0))
			AND
				(listFindNoCase("top,both", attributes.errorMessagePlacement) GT 0)>
		<cfoutput>
		<div id="errorMsg">
			<h3>#attributes.errorTitle#</h3>
			<p>#attributes.errorMessage#</p></cfoutput>
			<cfmodule template="#_config.renderer#" errors="#err#" errorListType="#listType#" />
		<cfoutput>
		</div>
		</cfoutput>
	</cfif>
	<!--- END: validation error check --->

	<!--- add okMsg --->
	<cfif len(attributes.okMsg) GT 0>
		<cfoutput><div id="OKMsg"><p>#attributes.okMsg#</p></div></cfoutput>
	</cfif>

	<!--- add any generated content --->
	<cfoutput>#__generatedContent#</cfoutput>

		<cfloop from="1" to="#arrayLen(thisTag.fieldsets)#" index="i">
			<cfoutput>#thisTag.fieldsets[i].fullContent#</cfoutput>
		</cfloop>

		<!--- BEGIN: build the prerequisite JavaScript/CSS --->
		<!--- BEGIN: loadjQuery check --->
		<cfif attributes.loadjQuery>
			<cfsavecontent variable="_jQ">
				<cfoutput><script src="#_config.jQuery#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadjQuery check --->

		<!--- BEGIN: loadjQueryUI check --->
		<cfif attributes.loadjQueryUI>
			<cfsavecontent variable="_jqui">
				<cfoutput><script src="#_config.jqui#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadjQueryUI check --->
		<!--- BEGIN: loadjQueryUICSS check --->
		<cfif attributes.loadjQueryUICSS>
			<cfsavecontent variable="_jquiCSS">
				<cfoutput><link href="#_config.jquiCSS#" type="text/css" rel="stylesheet" media="all" /></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadjQueryUI check --->

		<!--- BEGIN: loadDefaultCSS check --->
		<cfif attributes.loadDefaultCSS>
			<!--- standard CSS items for all Uni-Form markup forms --->
			<cfsavecontent variable="_stdCSS">
				<cfoutput><link href="#_config.uniformCSS#" type="text/css" rel="stylesheet" media="all" /><!--[if lte ie 8]><link href="#_config.uniformCSSie#" type="text/css" rel="stylesheet" media="all" /><![endif]--><link href="#_config.uniformThemeCSS#" type="text/css" rel="stylesheet" media="all" /></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadDefaultCSS check --->
		<!--- BEGIN: loadDefaultJS check --->
		<cfif attributes.loadDefaultJS>
			<!--- standard JS items for all Uni-Form markup forms --->
			<cfsavecontent variable="_stdJS">
				<cfoutput><script src="#_config.uniformJS#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadDefaultJS check --->

		<!--- BEGIN: configForm check --->
		<cfif attributes.configForm>
			<!--- config this form with the uniform js --->
			<cfscript>
				jsConfig = jsConfig & 'jQuery("##' & attributes.id & '").uniform();';
			</cfscript>
		</cfif>
		<!--- END: configForm check --->

		<!--- BEGIN: loadValidation check --->
		<cfif attributes.loadValidation>
			<!--- validation JS requirements --->
			<cfsavecontent variable="_validJS">
				<cfoutput><script src="#_config.validationJS#" type="text/javascript"></script><script src="#_config.inputJS#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadValidation check --->
		<!--- BEGIN: configValidation stuff --->
		<!--- if we're loading VT, let it do the main validation config --->
		<cfif isObject(attributes.VT) AND isObject(attributes.VTtarget)>
			<cfscript>
				_vtConfig = attributes.VT.getInitializationScript(JSincludes=false);
				_vtScript = attributes.VT.getValidationScript(theObject=attributes.VTtarget,formName=attributes.id,context=attributes.VTcontext,locale=attributes.VTlocale);
				_vtScript = reReplace(_vtScript,'(<script type="text/javascript">jQuery\(document\)\.ready\(function\((\jQuery)?\) \{|\}\);</script>)',"","all");
				jsConfig = jsConfig & _vtScript;
			</cfscript>
		</cfif>
		<!--- if we should config validation... --->
		<cfif attributes.configValidation>
			<cfscript>
				_validationSetup = "";
				if ( isSimpleValue(attributes.validationSetup) AND len(trim(attributes.validationSetup)) GT 0 )
				{
					_validationSetup = attributes.validationSetup;
				}
				else if ( isStruct(attributes.validationSetup)
								AND
									structCount(attributes.validationSetup) GT 0 )
				{
					_validationSetup = buildConfigString(attributes.validationSetup);
				}
				jsConfig = jsConfig & " jQuery('###attributes.id#').validate(" & _validationSetup & ");";
			</cfscript>
		</cfif>
		<!--- END: configValidation check --->

		<!--- BEGIN: loadDateUI check --->
		<cfif attributes.loadDateUI AND attributes.loadjQueryUI IS FALSE AND attributes.usejQueryUI IS FALSE>
			<!--- dateUI CSS requirements --->
			<cfsavecontent variable="_dateCSS">
				<cfoutput>
				<link href="#_config.dateCSS#" rel="stylesheet" type="text/css" /></cfoutput>
			</cfsavecontent>
			<cfsavecontent variable="_dateJS">
				<cfoutput><script src="#_config.dateJS#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadDateUI check --->
		<!--- BEGIN: configDateUI check --->
		<cfif attributes.configDateUI>
			<!--- dateUI JS requirements --->
			<cfscript>
				_dateSetup = getDateSetup();
				if ( len(trim(_dateSetup)) GT 0 )
				{
					if ( attributes.usejQueryUI == false && attributes.loadjQueryUI == false )
					{
						// default behavior is to use the original datepicker plugin
						jsConfig = jsConfig & " jQuery.datepick.setDefaults(" & _dateSetup & ");";
					}
					else
					{
						// the user has opted to use jQuery UI
						jsConfig = jsConfig & " jQuery.datepicker.setDefaults(" & _dateSetup & ");";
					}
				}
				// now config the generic fields - that is, fields that did *not* provide any field-level configs.
				if ( attributes.usejQueryUI == false && attributes.loadjQueryUI == false )
				{
					// default behavior is to use the original datepicker plugin
					jsConfig = jsConfig & " jQuery('##" & attributes.id & " .addDatePicker').datepick();";
				}
				else
				{
					// the user has opted to use jQuery UI
					jsConfig = jsConfig & " jQuery('##" & attributes.id & " .addDatePicker').datepicker();";
				}
				// do we have any date setups passed into specific field(s)?
				for ( f=1; f LTE arrayLen(thisTag.fieldsets); f=f+1 )
				{
					dateGroup = thisTag.fieldsets[f].dateSetups;
					keys = structKeyArray(dateGroup);
					for ( k=1; k LTE arrayLen(keys); k=k+1 )
					{
						// these are applied only to this field
						_dateSetup = dateGroup[keys[k]];
						if ( isStruct(_dateSetup) )
						{
							_dateSetup = buildConfigString(_dateSetup);
						}
						if ( attributes.usejQueryUI == false && attributes.loadjQueryUI == false )
						{
							// default behavior is to use the original datepicker plugin
							jsConfig = jsConfig & " jQuery('##" & attributes.id & " ##" & keys[k] & "').datepick(" & _dateSetup & ");";
						}
						else
						{
							// the user has opted to use jQuery UI
							jsConfig = jsConfig & " jQuery('##" & attributes.id & " ##" & keys[k] & "').datepicker(" & _dateSetup & ");";
						}
					}
				}
			</cfscript>
		</cfif>
		<!--- END: configDateUI check --->

		<!--- BEGIN: loadTimeUI check --->
		<cfif attributes.loadTimeUI>
			<cfif attributes.loadjQueryUI IS FALSE AND attributes.usejQueryUI IS FALSE>
				<!--- timeUI CSS requirements --->
				<cfsavecontent variable="_timeCSS">
					<cfoutput>
					<link href="#_config.timeCSS#" rel="stylesheet" type="text/css" /></cfoutput>
				</cfsavecontent>
				<!--- timeUI JS requirements --->
				<cfsavecontent variable="_timeJS">
					<cfoutput><script src="#_config.timeJS#" type="text/javascript"></script></cfoutput>
				</cfsavecontent>
			<cfelse>
				<!--- timeUI JS requirements --->
				<cfsavecontent variable="_timeJS">
					<cfoutput><script src="#_config.jquiTimeJS#" type="text/javascript"></script></cfoutput>
				</cfsavecontent>
			</cfif>
		</cfif>
		<!--- END: loadTimeUI check --->
		<!--- BEGIN: configTimeUI check --->
		<cfif attributes.configTimeUI>
			<cfscript>
				_timeSetup = getTimeSetup();
				if ( len(trim(_timeSetup)) GT 0 )
				{
					if ( attributes.usejQueryUI == false && attributes.loadjQueryUI == false )
					{
						// default behavior is to use the original timeEntry plugin
						jsConfig = jsConfig & " jQuery.timeEntry.setDefaults(" & _timeSetup & ");";
					}
					else
					{
						// the user has opted to use jQuery UI
						jsConfig = jsConfig & " jQuery.timepicker.setDefaults(" & _timeSetup & ");";
					}
				}
				// now config the generic fields - that is, fields that did *not* provide any field-level configs.
				if ( attributes.usejQueryUI == false && attributes.loadjQueryUI == false )
				{
					// default behavior is to use the original timeEntry plugin
					jsConfig = jsConfig & " jQuery('##" & attributes.id & " .addTimePicker').timeEntry();";
				}
				else
				{
					// the user has opted to use jQuery UI
					jsConfig = jsConfig & " jQuery('##" & attributes.id & " .addTimePicker').timepicker({});";
				}
				// do we have any time setups passed into specific field(s)?
				for ( f=1; f LTE arrayLen(thisTag.fieldsets); f=f+1 )
				{
					timeGroup = thisTag.fieldsets[f].timeSetups;
					keys = structKeyArray(timeGroup);
					for ( k=1; k LTE arrayLen(keys); k=k+1 )
					{
						// these are applied only to this field
						_timeSetup = timeGroup[keys[k]];
						if ( isStruct(_timeSetup) )
						{
							_timeSetup = buildConfigString(_timeSetup);
						}
						if ( attributes.usejQueryUI == false && attributes.loadjQueryUI == false )
						{
							// default behavior is to use the original timeEntry plugin
							jsConfig = jsConfig & " jQuery('##" & attributes.id & " ##" & keys[k] & "').timeEntry(" & _timeSetup & ");";
						}
						else
						{
							// the user has opted to use jQuery UI
							jsConfig = jsConfig & " jQuery('##" & attributes.id & " ##" & keys[k] & "').timepicker(" & _timeSetup & ");";
						}
					}
				}
			</cfscript>
		</cfif>
		<!--- END: configTimeUI check --->

		<!--- BEGIN: configTimestampUI check --->
		<cfif attributes.configTimestampUI AND (attributes.usejQueryUI OR attributes.loadjQueryUI)>
			<cfscript>
				_timeSetup = getTimeSetup();
				if ( len(trim(_timeSetup)) GT 0 )
				{
					jsConfig = jsConfig & " jQuery.timepicker.setDefaults(" & _timeSetup & ");";
				}
				// now config the generic fields - that is, fields that did *not* provide any field-level configs.
				jsConfig = jsConfig & " jQuery('##" & attributes.id & " .addTimestampPicker').datetimepicker({});";
				// do we have any time setups passed into specific field(s)?
				for ( f=1; f LTE arrayLen(thisTag.fieldsets); f=f+1 )
				{
					timestampGroup = thisTag.fieldsets[f].timestampSetups;
					keys = structKeyArray(timestampGroup);
					for ( k=1; k LTE arrayLen(keys); k=k+1 )
					{
						// these are applied only to this field
						_timestampSetup = timestampGroup[keys[k]];
						if ( isStruct(_timestampSetup) )
						{
							_timestampSetup = buildConfigString(_timestampSetup);
						}
						jsConfig = jsConfig & " jQuery('##" & attributes.id & " ##" & keys[k] & "').datetimepicker(" & _timestampSetup & ");";
					}
				}
			</cfscript>
		</cfif>
		<!--- END: configTimestampUI check --->

		<!--- BEGIN: loadMaskUI check --->
		<cfif attributes.loadMaskUI>
			<cfsavecontent variable="_maskJS">
				<cfoutput><script src="#_config.maskJS#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadMaskUI check --->
		<!--- BEGIN: configMaskUI check --->
		<cfif attributes.configMaskUI>
			<!--- add any masks to the jsConfig JavaScript --->
			<cfscript>
				for (f=1; f LTE arrayLen(thisTag.fieldsets); f=f+1)
				{
					maskGroup = thisTag.fieldsets[f].masks;
					keys = structKeyArray(maskGroup);
					for (k=1; k LTE arrayLen(keys); k=k+1)
					{
						jsConfig = jsConfig & " jQuery('##" & attributes.id & " ##" & keys[k] & "').mask('" & maskGroup[keys[k]] & "');";
					}
				}
			</cfscript>
		</cfif>
		<!--- END: configMaskUI check --->

		<!--- BEGIN: loadTextareaResize check --->
		<cfif attributes.loadTextareaResize>
			<!--- Textarea resize JS requirements --->
			<cfsavecontent variable="_textareaJS">
				<cfoutput><script src="#_config.textareaJS#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
			<cfset jsConfig = jsConfig & " jQuery('##" & attributes.id & " .resizableTextarea').elastic();" />
		</cfif>
		<!--- END: loadTextareaResize check --->
		
		<!--- BEGIN: loadRatingUI check --->
		<cfif attributes.loadRatingUI>
			<!--- ratingUI CSS requirements --->
			<cfsavecontent variable="_ratingCSS">
				<cfoutput>
				<link href="#_config.ratingCSS#" rel="stylesheet" type="text/css" /></cfoutput>
			</cfsavecontent>
			<!--- ratingUI JS requirements --->
			<cfsavecontent variable="_ratingJS">
				<cfoutput><script src="#_config.ratingJS#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadRatingUI check --->
		<!--- BEGIN: configRatingUI check --->
		<cfif attributes.configRatingUI>
			<!--- add any ratings to the jsConfig JavaScript --->
			<cfscript>
				for (f=1; f LTE arrayLen(thisTag.fieldsets); f=f+1)
				{
					ratingGroup = thisTag.fieldsets[f].ratingSetups;
					keys = structKeyArray(ratingGroup);
					for (k=1; k LTE arrayLen(keys); k=k+1)
					{
						jsConfig = jsConfig & " jQuery('##" & attributes.id & " :input[name=""" & keys[k] & """]').rating(" & ratingGroup[keys[k]] & ");";
					}
				}
			</cfscript>
		</cfif>
		<!--- END: configRatingUI check --->

		<cfscript>
			_CSS = _stdCSS & _jquiCSS & _dateCSS & _timeCSS & _ratingCSS;
			_JS = _jQ & _jqui & _validJS & _dateJS & _timeJS & _maskJS & _textareaJS & _ratingJS & _vtConfig & _stdJS;
			if ( len(jsConfig) GT 0 )
			{
				jsConfig = '<script type="text/javascript">jQuery(document).ready(function() {' & jsConfig & ' });</script>';
			}
		</cfscript>
		<!--- END: build the prerequisite JavaScript/CSS --->

		<!--- check <head> loads --->
		<cfif attributes.loadDefaultCSS AND len(attributes.cssLoadVar) EQ 0>
			<!--- load the CSS --->
			<cfhtmlhead text="#_CSS#" />
		<cfelseif attributes.loadDefaultCSS AND len(attributes.cssLoadVar) GT 0>
			<cfset caller[attributes.cssLoadVar] = _CSS />
		</cfif>
		<!--- if we do *not* have a jsLoadVar... --->
		<cfif len(attributes.jsLoadVar) EQ 0>
			<cfif attributes.loadDefaultJS AND attributes.addJStoHead>
				<!--- load the default JS to the <head> --->
				<cfhtmlhead text="#_JS#" />
			</cfif>
			<cfif attributes.addJStoHead AND len(attributes.jsConfigVar) EQ 0>
				<!--- no jsConfigVar; add it to the <head> --->
				<cfhtmlhead text="#jsConfig#" />
			<cfelseif attributes.addJStoHead AND len(attributes.jsConfigVar) GT 0>
				<!--- we have a jsConfigVar; return jsConfig to the caller --->
				<cfset caller[attributes.jsConfigVar] = jsConfig />
			</cfif>
		<!--- if we *do* have a jsLoadVar... --->
		<cfelse>
			<cfscript>
				if ( len(attributes.jsConfigVar) EQ 0 )
				{
					_JS = _JS & " " & jsConfig;
				}
				else
				{
					caller[attributes.jsConfigVar] = jsConfig;
				}
				caller[attributes.jsLoadVar] = _JS;
			</cfscript>
		</cfif>

	<!--- BEGIN: showSubmit check --->
	<cfif attributes.showSubmit>
		<cfoutput><div class="buttonHolder"></cfoutput>
		<cfif attributes.showReset>
			<cfoutput><button type="reset" class="resetButton">#attributes.resetValue#</button>&nbsp;</cfoutput>
		</cfif>
		<cfif len(attributes.submit2Name) GT 0 AND len(attributes.submit2Value) GT 0 AND attributes.submit2placement IS "left">
			<cfoutput><button type="submit" class="primaryAction float-left" name="#attributes.submit2name#">#attributes.submit2value#</button>&nbsp;</cfoutput>
		</cfif>
		<cfif len(attributes.submit2Name) GT 0 AND len(attributes.submit2Value) GT 0 AND attributes.submit2placement IS "before">
			<cfoutput><button type="submit" class="primaryAction" name="#attributes.submit2name#">#attributes.submit2value#</button>&nbsp;</cfoutput>
		</cfif>

			<cfoutput><button type="submit" class="primaryAction #attributes.submitButtonAddClass#" name="#attributes.submitName#" id="#attributes.submitName#">#attributes.submitValue#</button></cfoutput>

		<cfif len(attributes.submit2Name) GT 0 AND len(attributes.submit2Value) GT 0 AND attributes.submit2placement IS "after">
			<cfoutput>&nbsp;<button type="submit" class="primaryAction" name="#attributes.submit2name#">#attributes.submit2value#</button></cfoutput>
		</cfif>
		<cfif attributes.showCancel>
			<cfoutput>&nbsp;<button class="secondaryAction cancel" name="#attributes.cancelName#" id="#attributes.cancelName#">#attributes.cancelValue#</button></cfoutput>
		</cfif>
		<cfoutput></div></cfoutput>
	</cfif>
	<!--- END: showSubmit check --->

	<cfoutput></form></cfoutput>
	<!--- if we are suppose to load the JS and did not load to the head, load now --->
	<cfif (len(attributes.jsLoadVar) EQ 0) AND attributes.loadDefaultJS AND NOT attributes.addJStoHead>
		<cfoutput>#_JS#</cfoutput>
	</cfif>
	<!--- do we need to add the jsConfig? --->
	<cfif (len(attributes.jsLoadVar) EQ 0) AND NOT attributes.addJStoHead AND len(attributes.jsConfigVar) EQ 0>
		<!--- no jsConfigVar; add jsConfig to output --->
		<cfoutput>#jsConfig#</cfoutput>
	</cfif>

</cfif>
<!--- END: executionMode check --->
<cfsetting enablecfoutputonly="no" />
