'use strict';
'require form';
'require view';

return view.extend({
	render: function () {
		var m, s, o;

		m = new form.Map('gps', _('ugps'),
			_('ugps is a gps service daemon, here you can configure the settings.'));

		s = m.section(form.TypedSection, 'gps');
		s.anonymous = true;
		s.addremove = true;

		o = s.option(form.Flag, 'disabled', _('Enabled'));
		o.enabled = '0';
		o.disabled = '1';
		o.default = o.disabled;
		o.rmempty = false;

		o = s.option(form.Value, 'tty', _('Device Name'));
		o.default = 'ttyACM0';
		o.rmempty = false;

		o = s.option(form.Flag, 'adjust_time', _('Adjust Time'));
		o.default = '1';
		o.rmempty = false;

		o = s.option(form.Value, 'baud_rate', _('Baud Rate'));
		o.default = '9600';
		o.rmempty = true;

		return m.render();
	}
});
