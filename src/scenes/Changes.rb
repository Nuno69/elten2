# A part of Elten - EltenLink / Elten Network desktop client.
# Copyright (C) 2014-2021 Dawid Pieper
# Elten is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.
# Elten is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with Elten. If not, see <https://www.gnu.org/licenses/>.

class Scene_Changes
  def main
    versions = [
      ["1.0", "2014-08-24"],
      ["1.01", "2014-08-24"],
      ["1.02", "2014-08-24"],
      ["1.03", "2014-09-06"],
      ["1.04", "2014-10-19"],
      ["1.05", "2014-11-28"],
      ["1.06", "2014-12-23"],
      ["1.07", "2014-12-24"],
      ["1.08", "2014-12-31"],
      ["1.09", "2015-01-29"],
      ["1.091", "2015-01-29"],
      ["1.092", "2015-02-07"],
      ["1.093", "2015-02-13"],
      ["1.1", "2015-03-28"],
      ["1.11", "2015-03-29"],
      ["1.12", "2015-03-29"],
      ["1.13", "2015-04-30"],
      ["1.14", "2015-05-08"],
      ["1.15", "2015-05-21"],
      ["1.16", "2015-05-27"],
      ["1.2", "2015-06-20"],
      ["1.21", "2015-08-08"],
      ["1.22", "2015-08-10"],
      ["1.3", "2015-08-24"],
      ["1.31", "2015-08-24"],
      ["1.32", "2015-08-29"],
      ["1.33", "2015-08-29"],
      ["1.34", "2015-08-31"],
      ["1.35", "2015-09-06"],
      ["1.36", "2015-09-06"],
      ["1.37", "2015-09-22"],
      ["1.38", "2015-09-22"],
      ["1.39", "2015-11-20"],
      ["1.391", "2015-11-27"],
      ["1.392", "2015-12-23"],
      ["1.393", "2015-12-25"],
      ["1.394", "2016-03-08"],
      ["1.395", "2016-07-22"],
      ["1.396", "2016-07-22"],
      ["1.397", "2016-09-09"],
      ["1.398", "2016-11-19"],
      ["1.399", "2016-12-22"],
      ["1.3991", "2017-03-24"],
      ["1.3992", "2017-03-26"],
      ["1.3993", "2017-03-27"],
      ["1.3994", "2017-03-27"],
      ["2.0", "2017-08-24"],
      ["2.01", "2017-08-25"],
      ["2.02", "2017-08-26"],
      ["2.03", "2017-08-27"],
      ["2.031", "2017-08-28"],
      ["2.04", "2017-08-28"],
      ["2.041", "2017-08-29"],
      ["2.042", "2017-08-31"],
      ["2.043", "2017-09-04"],
      ["2.1", "2017-10-28"],
      ["2.11", "2017-10-30"],
      ["2.12", "2017-11-01"],
      ["2.13", "2017-11-05"],
      ["2.14", "2017-11-10"],
      ["2.15", "2017-11-11"],
      ["2.16", "2017-11-26"],
      ["2.17", "2017-12-06"],
      ["2.18", "2018-01-03"],
      ["2.181", "2018-01-06"],
      ["2.2", "2018-02-24"],
      ["2.21", "2018-02-26"],
      ["2.22", "2018-03-24"],
      ["2.221", "2018-03-28"],
      ["2.222", "2018-03-31"],
      ["2.223", "2018-04-11"],
      ["2.224", "2018-04-16"],
      ["2.23", "2018-04-23"],
      ["2.24", "2018-04-29"],
      ["2.241", "2018-04-30"],
      ["2.242", "2018-04-30"],
      ["2.243", "2018-05-03"],
      ["2.25", "2018-06-17"],
      ["2.26", "2018-06-17"],
      ["2.27", "2018-07-26"],
      ["2.271", "2018-07-26"],
      ["2.28", "2018-07-30"],
      ["2.281", "2018-09-08"],
      ["2.282", "2018-09-25"],
      ["2.283", "2018-10-21"],
      ["2.284", "2018-11-08"],
      ["2.285", "2019-03-09"],
      ["2.3", "2019-08-24"],
      ["2.31", "2019-08-26"],
      ["2.32", "2019-09-10"],
      ["2.33", "2019-09-14"],
      ["2.34", "2019-09-27"],
      ["2.341", "2019-09-28"],
      ["2.342", "2019-10-01"],
      ["2.35", "2019-10-14"],
      ["2.36", "2019-12-23"],
      ["2.361", "2020-02-01"],
      ["2.37", "2020-06-14"],
      ["2.38", "2020-10-19"],
      ["2.4", "2021-01-24"],
      ["2.401", "2021-01-28"],
      ["2.402", "2021-01-29"],
      ["2.403", "2021-02-24"],
      ["2.41", "2021-03-10"],
      ["2.411", "2021-03-17"],
      ["2.412", "2021-03-17"],
      ["2.413", "2021-04-16"],
      ["2.42", "2021-05-15"],
      ["2.421", "2021-05-28"]
    ]
    verstring = "Elten"
    @changes = versions.map { |v|
      verdots = v[0].delete(".").split("").join(".")
      "#{verstring} #{verdots}:
#{_doc("changelog/" + verdots.gsub(".", "_"))}

#{v[1]}"
    }
    @changes.reverse!
    @selt = []
    for i in 0..@changes.size - 1
      @selt.push((@changes[i]).split("\n")[0].delete(":").sub(verstring + " ", ""))
    end
    @sel = ListBox.new(@selt, p_("Changes", "Changelog"))
    loop do
      loop_update
      @sel.update
      update
      break if $scene != self
    end
  end

  def update
    if escape
      $scene = Scene_Main.new
    end
    if enter
      input_text(@selt[@sel.index], EditBox::Flags::ReadOnly, @changes[@sel.index], true)
      @sel.focus
    end
  end
end
