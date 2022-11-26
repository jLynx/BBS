import logging
import requests

HOST_REPORT_TIME = 1.0


class BeltBalanceSystem:
    def __init__(self, config):
        self.printer = config.get_printer()
        self.reactor = self.printer.get_reactor()
        self.name = config.get_name().split()[-1]

        self.temp = self.min_temp = self.max_temp = 0.0
        self.belt_number = 1

        self.printer.add_object("belt_balance_system " + self.name, self)
        if self.printer.get_start_args().get('debugoutput') is not None:
            return
        self.sample_timer = self.reactor.register_timer(
            self._sample_belt_tensions)

        self.printer.register_event_handler("klippy:connect",
                                            self.handle_connect)

    def handle_connect(self):
        self.reactor.update_timer(self.sample_timer, self.reactor.NOW)

    def setup_minmax(self, min_temp, max_temp):
        self.belt_number = min_temp

    def setup_callback(self, cb):
        self._callback = cb

    def get_report_time_delta(self):
        return HOST_REPORT_TIME

    def _sample_belt_tensions(self, eventtime):
        try:
            response = requests.get("http://192.168.1.203/weight")
            values = response.content.split(",")
            logging.exception(self.belt_number)
            logging.exception(self.belt_number - 1)
            self.temp = float(values[int(self.belt_number - 1)])
        except Exception:
            logging.exception("belt_balance_system: Error reading data")
            self.temp = 0.0
            return self.reactor.NEVER

        mcu = self.printer.lookup_object('mcu')
        measured_time = self.reactor.monotonic()
        # self.temp = 200
        self._callback(mcu.estimated_print_time(measured_time), self.temp)
        return measured_time + HOST_REPORT_TIME

    def get_status(self, eventtime):
        return {
            'temperature': round(self.temp, 2),
        }


def load_config(config):
    # Register sensor
    pheaters = config.get_printer().load_object(config, "heaters")
    pheaters.add_sensor_factory("belt_balance_system", BeltBalanceSystem)
