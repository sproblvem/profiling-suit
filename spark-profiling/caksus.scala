#!/bin/sh
  exec scala "$0" "$@"
!#

import scala.io.Source
import scala.collection.immutable.SortedMap

object Caksus {
  def main(args: Array[String]) {
    val fields = Source
      .fromFile(args(0))
      .getLines()
      .filter(_ contains "TASK_TYPE=RESULT_TASK")
      .map(_ split " ")
      .toSeq

    val hosts = fields.map(_(9)).toSeq.groupBy(identity)

    val kv = fields.map(x => (x(9), x(12)))
      .groupBy(_._1)
      .mapValues(_.map(_._2).map(_.drop(14)))

    for (key <- kv.keys.toSeq.sorted) {
      println(kv(key).size + "\t" 
        + key + "\t"
        + (kv(key) mkString " ") + "\t=avg=\t"
        + kv(key).map(_.toInt).sum / kv(key).size)
    }   
  }
}


Caksus.main(args)
