import React, { useState, useEffect } from 'react';
import './App.css';

const App = () => {
  const [passwords, setPasswords] = useState([]);

  useEffect(() => {
    getPasswords();
  }, [])

  const getPasswords = () => {
    fetch('/api/passwords')
      .then(res => res.json())
      .then(passwords => setPasswords(passwords));
  }

  return (
    <div className="App">
      {passwords.length
      ? <div>
          <h1>5 Passwords.</h1>
          <ul className="passwords">
            {passwords.map((password, index) => 
              <li key={index}>{password}</li>
            )}
          </ul>
          <button className="more" onClick={() => getPasswords()}>
            Get More
          </button>
        </div>
      : <div>
          <h1>No passwords :(</h1>
          <button className="more" onClick={() => getPasswords()}>
            Try Again?
          </button>
        </div>
      }
    </div>
  );
}

export default App;
