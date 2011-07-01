jQuery.fn.uniform = function(settings) {
  settings = jQuery.extend({
    valid_class    : 'valid',
    invalid_class  : 'invalid',
    focused_class  : 'focused',
    holder_class   : 'ctrlHolder',
    field_selector : 'input, select, textarea'
  }, settings);
  
  return this.each(function() {
    var form = jQuery(this);
    
    // Focus specific control holder
    var focusControlHolder = function(element) {
      var parent = element.parent();
      
      while(typeof(parent) == 'object') {
        if(parent) {
          if(parent[0] && (parent[0].className.indexOf(settings.holder_class) >= 0)) {
            parent.addClass(settings.focused_class);
            return;
          } // if
        } // if
        parent = jQuery(parent.parent());
      } // while
    };
    
    // Select form fields and attach them higlighter functionality
    form.find(settings.field_selector).focus(function() {
      form.find('.' + settings.focused_class).removeClass(settings.focused_class);
      focusControlHolder(jQuery(this));
    }).blur(function() {
      form.find('.' + settings.focused_class).removeClass(settings.focused_class);
    });
  });
};

// Auto set on page load...
$(document).ready(function() {
	jQuery('form.uniForm').uniform();
	
	/* cfUniForm integration */
	try { // try to set the validator
		jQuery.validator.setDefaults({
			errorClass:'errorField',
			errorElement:'p',
			errorPlacement:function(error, element) {
				error.prependTo(element.parents('div.ctrlHolder'))
			},
			highlight:function(element,errorClass) {
				$(element).parents('div.ctrlHolder').addClass('error');
			},
			unhighlight:function(element,errorClass) {
				$(element).parents('div.ctrlHolder').removeClass('error');
			}
		});
	} catch (e) {}
	var dateOptions = {
	 	showOn:'both',
		buttonText:'Select Date',
		buttonImage:'/commonassets/images/uni-form/calendar.png',
		buttonImageOnly:true
	};
	try { // try to set the datepicker defaults (Keith Wood)
		jQuery.datepick.setDefaults(dateOptions);
	} catch (e2) {}
	try { // try to set the datepicker defaults (jQuery UI)
		jQuery.datepicker.setDefaults(dateOptions);
	} catch (e2) {}
	try { // try to set the timeentry defaults (Keith Wood)
		jQuery.timeEntry.setDefaults({
			show24Hours:false,
		 	spinnerImage:'/commonassets/images/timeentry/spinnerDefault.png'
		});
	} catch (e3) {}
	try { // try to set the timepicker defaults (jQuery UI)
		jQuery.timepicker.setDefaults({
			timeFormat:"h:mm tt",
			buttonText:"Enter Time",
			buttonImage:"/commonassets/images/uni-form/clock.png",
			buttonImageOnly:true
		});
	} catch (e2) {}
});