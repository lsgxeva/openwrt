'use strict';
'require form';
'require view';

return view.extend({
	render: function () {
		var m, s, o;

		m = new form.Map('checknet', _('checknet'),
			_('checknet is a Double LTE Checknet Script daemon, here you can configure the settings.'));

		s = m.section(form.TypedSection, 'checknet');
		s.anonymous = true;
		s.addremove = true;

		o = s.option(form.Flag, 'disabled', _('Enabled'));
		o.enabled = '0';
		o.disabled = '1';
		o.default = o.disabled;
		o.rmempty = false;

		o = s.option(form.Value, 'second', _('Cycle Second'));
		o.default = 10;
		o.datatype = 'range(3, 59)';
		o.rmempty = false;

		o = s.option(form.Flag, 'respawn', _('Respawn'));
		o.default = '1';
		o.rmempty = false;

		o = s.option(form.Flag, 'log_enabled', _('Log Enabled'));
		o.default = '0';
		o.rmempty = false;

		o = s.option(form.Value, 'wan_zone', _('Wan Firewall Zone Name'));
		o.default = 'wan';
		o.rmempty = true;

		o = s.option(form.Value, 'lte1_zone', _('LTE1 Firewall Zone Name'));
		o.default = 'lte1';
		o.rmempty = true;

		o = s.option(form.Value, 'lte2_zone', _('LTE2 Firewall Zone Name'));
		o.default = 'lte2';
		o.rmempty = true;

		o = s.option(form.Value, 'wan_ifname', _('Wan Interface Name'));
		o.default = 'eth1';
		o.rmempty = true;

		o = s.option(form.Value, 'lte1_ifname', _('LTE1 Interface Name'));
		o.default = 'wwan0';
		o.rmempty = true;

		o = s.option(form.Value, 'lte2_ifname', _('LTE2 Interface Name'));
		o.default = 'wwan1';
		o.rmempty = true;

		o = s.option(form.Value, 'modem_dev1', _('LTE1 Modem Device Name'));
		o.default = 'cdc-wdm0';
		o.rmempty = true;

		o = s.option(form.Value, 'modem_dev2', _('LTE2 Modem Device Name'));
		o.default = 'cdc-wdm1';
		o.rmempty = true;

		o = s.option(form.Value, 'modem_dial', _('LTE Modem Dial Proc'));
		o.default = 'quectel-CM';
		o.rmempty = true;

		o = s.option(form.Value, 'dial_apn_cmnet', _('China Mobile Dial APN'));
		o.default = 'cmnet';
		o.rmempty = true;

		o = s.option(form.Value, 'dial_apn_cmtds', _('China Unicom Dial APN'));
		o.default = '3gnet';
		o.rmempty = true;

		o = s.option(form.Value, 'dial_apn_ctlte', _('China Telecom Dial APN'));
		o.default = 'ctnet';
		o.rmempty = true;

		o = s.option(form.Value, 'ttyusb_at1', _('LTE1 AT ttyUSB Device'));
		o.default = 'ttyUSB2';
		o.rmempty = true;

		o = s.option(form.Value, 'ttyusb_at2', _('LTE2 AT ttyUSB Device'));
		o.default = 'ttyUSB6';
		o.rmempty = true;

		return m.render();
	}
});
