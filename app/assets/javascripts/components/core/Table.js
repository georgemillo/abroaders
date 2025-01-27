import React, { PropTypes } from "react";
import classnames from "classnames";

const Table = (_props) => {
  const props = Object.assign({}, _props);

  props.className = classnames([
    props.className,
    {
      table:           true,
      "table-striped": props.striped,
    },
  ]);

  return React.createElement("table", props);
};

Table.propTypes = {
  className: PropTypes.string,
  striped:   PropTypes.bool,
};

export default Table;
