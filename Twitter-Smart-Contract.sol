// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;



contract Twitter {


    //Defining my Tweet Structure
    struct Tweet {
        uint256 tweet_id;
        address author;
        string content;
        uint256 timestamp;
        uint256 like; 
    }
     

    //mapping an address to an list of Tweets
    mapping(address => Tweet[]) public tweets;


    address public owner;
    uint256 public Tweetlength = 280;

    constructor (){
        owner =  msg.sender;
         }

    modifier onlyOwner(){
        require(msg.sender == owner, "you are not the owener");
        _;
         }

    function TweetTweeker(uint256 _newLength) public onlyOwner {
        Tweetlength = _newLength;
        }

    event NewTweetCreated(uint256 tweet_id,address author,string content,uint timestamp,uint256 like);

    function createTweet(string memory _tweetContent) public {
        
        require(bytes(_tweetContent).length <= Tweetlength, "Your Tweet is too long" );
        Tweet memory newTweet = Tweet({
            tweet_id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweetContent,
            timestamp: block.timestamp,
            like: 0
        });
       tweets[msg.sender].push(newTweet);

       emit NewTweetCreated(newTweet.tweet_id, newTweet.author, newTweet.content, newTweet.timestamp, newTweet.like);
    }

    function getindexedTweet( uint16 _i) view  public returns(Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getTweet(address _owner) view  public returns(Tweet[] memory) {
        return tweets[_owner];
    }

    function tweetCount(address _owner) public view returns(uint){
        return tweets[_owner].length;
    }

    event TweetLiked(address liker,address author,uint256 tweet_id, uint256 newLikeCount);

    function TweetLike(address author, uint256 tweet_id) external {
          require(tweets[author][tweet_id].tweet_id == tweet_id, "Stop cheating");
          tweets[author][tweet_id].like++;
            
        emit TweetLiked(msg.sender, author, tweet_id, tweets[author][tweet_id].like);
    }

     event TweetUniked(address unliker,address author,uint256 tweet_id, uint256 newLikeCount);
    function TweetUnLiked(address author, uint256 tweet_id) external {
          require(tweets[author][tweet_id].like > 0, "Stop Hating");
          tweets[author][tweet_id].like--;
        emit TweetUniked(msg.sender, author, tweet_id, tweets[author][tweet_id].like);
    }

    }

